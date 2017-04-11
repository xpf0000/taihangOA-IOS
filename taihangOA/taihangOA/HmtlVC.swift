//
//  HtmlVC.swift
//  lejia
//
//  Created by X on 15/11/12.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import WebKit
import Cartography

let TmpDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www").appendingPathComponent("oa")

func CleanWebCache()
{
    /* 取得Library文件夹的位置*/
    let libraryDir=NSSearchPathForDirectoriesInDomains(.libraryDirectory,.userDomainMask, true)[0];
    /* 取得bundle id，用作文件拼接用*/
    
    let bundleId  =  Bundle.main.infoDictionary!["CFBundleIdentifier"]
    
    /*
     * 拼接缓存地址，具体目录为App/Library/Caches/你的APPBundleID/fsCachedData
     */
    let webKitFolderInCachesfs = "\(libraryDir)/Caches/\(bundleId!)/fsCachedData"
    
    let cache = "\(libraryDir)/Caches/\(bundleId!)/WebKit"
    
    do
    {
        let _ = try? Foundation.FileManager.default.removeItem(atPath: webKitFolderInCachesfs)
        let _ = try? Foundation.FileManager.default.removeItem(atPath: cache)
    }
    
    
}



import JavaScriptCore

typealias JSHandleBlock = (String)->Void

class JSHandle
{
    var block:JSHandleBlock?
    
    func onMsgChange(_ b:@escaping JSHandleBlock)
    {
        block = b
    }
    
    var msg:String? = ""
    {
        didSet
        {
            if(msg != nil)
            {
                block?(msg!)
            }
            
        }
    }
    
    func jsMessage(_ message: String) {
        
        msg = message
        
    }

    deinit{
        print("JSHandle deinit !!!!!!!!!!!!!!!")
    }
    
}



protocol XJSExports : JSExport {
    var msg: String? { get set }
    func jsMessage(_ message: String) -> Void
}



class HtmlVC: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    
    var webView:WKWebView?
    var url=""
    var html:String=""
    var baseUrl:URL?
    var handle:JSHandle? = JSHandle()
    var isSub = false
    
    var inBoot = false
    
    func msgChanged(_ json:String) {
        
        let data=json.data(using: String.Encoding.utf8)
        
        do
        {
            let dic:Dictionary<String,AnyObject>? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? Dictionary<String,AnyObject>
            
            if(dic != nil)
            {
                print("js msg000: \(String(describing: dic))")
                handleMSG(dic)
            }
            
        }
        catch
        {
            print("js msg111: \(json)")
        }
    }
    
    func handleMSG(_ dic:Dictionary<String,AnyObject>?)
    {
        
    }
    
    func show()
    {
        if(webView == nil)
        {
            return
        }
        
        if(self.url != "")
        {
            if let u = url.urlRequest
            {
                webView?.load(u)
            }
            
        }
        else if(self.html != "")
        {
            webView?.loadHTMLString(self.html, baseURL: baseUrl)
        }
    }
    
    func gotoBack()
    {
        XWaitingView.hide()
        
        if isSub
        {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        if webView?.canGoBack == true
        {
            webView?.goBack()
        }
    }
    
    func reload()
    {
        //CleanWebCache()
        
        if let currentURL = self.webView?.url {
            let request = URLRequest(url: currentURL)
            self.webView?.load(request)
        }
        else
        {
            webView?.load(url.urlRequest!)
        }
    }
    
    override func pop() {
        
        handle?.msg = nil
        handle = nil
        
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        webView?.uiDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
        
        super.pop()
    }
    
    let scriptHandle = WKUserContentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
  
        handle?.onMsgChange { [weak self](msg) in
            
            self?.msgChanged(msg)
            
        }
        
        let config = WKWebViewConfiguration()
        
        scriptHandle.add(self, name: "JSHandle")
        
        let per = WKPreferences()
        per.javaScriptCanOpenWindowsAutomatically = true
        per.javaScriptEnabled = true
        config.preferences = per
        config.userContentController = scriptHandle
        
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        
        webView?.uiDelegate=self
        webView?.navigationDelegate=self
        webView?.scrollView.showsHorizontalScrollIndicator = false
        webView?.scrollView.showsVerticalScrollIndicator = false
        
        
        webView?.isOpaque = false
        webView?.backgroundColor = UIColor.white
        
        self.view.addSubview(webView!)
        
        constrain(webView!) { (view) in
            view.size == view.superview!.size
            view.center == view.superview!.center
        }
    
        self.show()
        
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let str = message.body as? String
        {
            handle?.msg = str
        }
        
    }
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = "\(navigationAction.request.url!)"
        
        if (!url.has("http://") && !url.has("https://") && !url.has(".html"))
        {
            UIApplication.shared.openURL(navigationAction.request.url!)
            
            decisionHandler(WKNavigationActionPolicy.cancel)
            
        } else {
            
            decisionHandler(WKNavigationActionPolicy.allow)
            
        }

 
        
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        XWaitingView.hide()
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        XWaitingView.hide()
        
    }
    
    
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            
            completionHandler()
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        
        return nil
        
        
    }
    
    
    
    deinit
    {
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        webView?.uiDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
        
        print("HtmlVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    
}
