//
//  ViewController.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Cartography
import SwiftyJSON
import WebKit
import Hero

class MineVC: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var webView:WKWebView?
    var url:URL?
    var html:String=""
    var baseUrl:URL?
    var handle:JSHandle? = JSHandle()
    var isSub = false
    
    var inBoot = false
    
    lazy var imagePicker:UIImagePickerController = UIImagePickerController()
    
    func msgChanged(_ json:String) {
        
        let data=json.data(using: String.Encoding.utf8)
        
        do
        {
            let json = JSON.init(data: data!)
            HandleJSMsg.handle(obj: json, vc: self)
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
        
        if(self.url != nil)
        {
            
            let request = URLRequest(url: url!)
            webView?.load(request)
            
            //            if let u = url.urlRequest
            //            {
            //                print("u: \(u)")
            //                webView?.load(u)
            //            }
            
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
            if(self.url != nil)
            {
                let request = URLRequest(url: url!)
                webView?.load(request)
            }
            else if(self.html != "")
            {
                webView?.loadHTMLString(self.html, baseURL: baseUrl)
            }
            
        }
    }
    
    func UserUpdateMobile()
    {
        self.webView?.evaluateJavaScript("javascript:usergetinfo('"+DataCache.Share.User.toDict().toJson()+"')", completionHandler: { (res, err) in
            
            print(res ?? "")
            print(err ?? "")
            
        })

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
        
        mine = self
        
        NotificationCenter.default.addObserver(self, selector:#selector(UserUpdateMobile), name: NSNotification.Name(rawValue: "UserUpdateMobile"), object: nil)
        
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
        
        let sh = UIApplication.shared.statusBarFrame.height
        
        constrain(webView!) { (view) in
            view.width == (view.superview?.width)!
            view.height == (view.superview?.height)!-sh
            view.centerX == (view.superview?.centerX)!
            view.centerY == (view.superview?.centerY)!+sh/2.0
        }
        
        let v = UIView()
        v.backgroundColor = "059bf1".color()
        self.view.addSubview(v)
        
        constrain(v) { (view) in
            view.width == (view.superview?.width)!
            view.height == sh
            view.top == (view.superview?.top)!
            view.left == (view.superview?.left)!
            
        }

        
        self.baseUrl = TmpDirURL
        self.url = TmpDirURL.appendingPathComponent("user_info.html")
        
        self.show()
        
        imagePicker.delegate=self
        imagePicker.allowsEditing=true
        imagePicker.modalTransitionStyle=UIModalTransitionStyle.coverVertical
        
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

    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

        
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
    
    func dodeinit()
    {
        NotificationCenter.default.removeObserver(self)
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        webView?.uiDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
        scriptHandle.removeAllUserScripts()
        scriptHandle.removeScriptMessageHandler(forName: "JSHandle")
    }
    
    deinit
    {
        dodeinit()
        print("MineVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!NetConnected)
        {
            XMessage.Share.show("未检测到网络连接,请检查网络")
        }
        
        self.webView?.evaluateJavaScript("javascript:reshowHeader()", completionHandler: { (res, err) in
            print(res ?? "")
            print(err ?? "")
        })
        
        
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
    
    
    
    func onUploadHeadPic(){
        
        let cameraSheet:UIActionSheet=UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil)
        cameraSheet.addButton(withTitle: "从相册选择")
        cameraSheet.addButton(withTitle: "拍照")
        
        cameraSheet.actionSheetStyle = UIActionSheetStyle.blackTranslucent;
        cameraSheet.show(in: UIApplication.shared.keyWindow!)
        
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        print(buttonIndex)
        
        if(buttonIndex == 1)
        {
            imagePicker.sourceType=UIImagePickerControllerSourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else if(buttonIndex == 2)
        {
            imagePicker.sourceType=UIImagePickerControllerSourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print(info)
        
        let type:String = (info[UIImagePickerControllerMediaType]as!String)
        //当选择的类型是图片
        if type=="public.image"
        {
            if let img = info[UIImagePickerControllerEditedImage]as?UIImage
            {
                let imgData = UIImageJPEGRepresentation(img,0.5)
                
                doUpload(img: imgData!)
                
                picker.dismiss(animated:true, completion:nil)
            }
        
        }
        
    }
    
    func doUpload(img:Data)
    {
        XWaitingView.show()
        var map : [String:Any] = [:]
        map["headimg.jpg"]=img
        map["id"] = DataCache.Share.User.id
        map["mobile"] = DataCache.Share.User.account
        
        Api.UserHeadEdit(data: map) { (res) in
            
            if(res != "")
            {
                DataCache.Share.User.avatar = res
                DataCache.Share.User.save()
                
            self.webView?.evaluateJavaScript("javascript:usergetinfo('"+DataCache.Share.User.toDict().toJson()+"')", completionHandler: { (res, err) in
                    print(res ?? "")
                    print(err ?? "")
                
                XWaitingView.hide()
                
                })

                
            }
            else
            {
                XWaitingView.hide()
            }
            
        }
        
        
    }
    
    

    
}

