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
import Kingfisher

class HomeVC: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {
    
    
    @IBOutlet weak var banner: XBanner!
    @IBOutlet weak var page: UIPageControl!
    
    var webView:WKWebView?
    var url:URL?
    var html:String=""
    var baseUrl:URL?
    var handle:JSHandle? = JSHandle()
    var isSub = false
    var inBoot = false
    
    var bannerArr:[XBannerModel] = []
    {
        didSet
        {
            banner.bannerArr = bannerArr
        }
    }
    
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
        
        let p = TmpDirURL.appendingPathComponent("index.html")
        
        let u = "\(p)?f=\(Date().timeIntervalSince1970)"
        
        self.url = URL(string: u)
        
        self.show()
        
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
    
    func countChange()
    {
        if let item = self.tabBarController?.tabBar.items?[1]
        {
            if(DataCache.Share.daibanCount > 0)
            {
                item.badgeValue = "\(DataCache.Share.daibanCount)"
            }
            else
            {
                item.badgeValue = nil
            }
            
        }
        
    }
    
    let scriptHandle = WKUserContentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        home = self
        banner.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector:#selector(reload), name: NSNotification.Name(rawValue: "NewDaiban"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(countChange), name: NSNotification.Name(rawValue: "DaibanCount"), object: nil)
        
        initTabBar()
         
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
        
        webView?.scrollView.isScrollEnabled = false
        
        self.view.addSubview(webView!)
        self.view.sendSubview(toBack: webView!)
        
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
        
        let p = TmpDirURL.appendingPathComponent("index.html")
        
        let u = "\(p)?f=\(Date().timeIntervalSince1970)"
        
        self.url = URL(string: u)
        
        self.show()
        banner.scrollInterval = 3.0
        _ = banner.onIndexChange {[weak self] (index, model) in
            self?.page.currentPage = index
        }.onImageView({(url, imageview) in
            let u = URL(string: url)
            imageview.kf.setImage(with:u)
        })
        
//        Api.SystemGetAPPSlide {[weak self] (arr) in
//            self?.bannerArr = arr
//        }
        
    }
    
    func initTabBar()
    {
        let arr:Array<UITabBarItem> = (self.tabBarController?.tabBar.items)!
        let scale = Int(UIScreen.main.scale)

        for (i,item) in arr.enumerated()
        {
            item.image="app_icon00\(i+1)@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            item.selectedImage="app_icon0\(i+1)@\(scale)x.png".image()!.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            
            item.setTitleTextAttributes([NSForegroundColorAttributeName:APPBlueColor,NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.selected)
            
            item.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13.0)], for: UIControlState.normal)
            
        }
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
        self.webView?.evaluateJavaScript("javascript:InitIndexView('"+DataCache.Share.User.toDict().toJson()+"')", completionHandler: { (res, err) in
            print(res ?? "")
            print(err ?? "")
        })
        banner.isHidden = false
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
        
    self.webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        self.webView?.uiDelegate=nil
        self.webView?.navigationDelegate=nil
        self.webView?.stopLoading()
        self.webView=nil
        self.scriptHandle.removeAllUserScripts()
        self.scriptHandle.removeScriptMessageHandler(forName: "JSHandle")
        
        CleanWebCache()

   
    }
    
    deinit
    {
        dodeinit()
        print("HomeVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!NetConnected)
        {
            XMessage.Share.show("未检测到网络连接,请检查网络")
        }
        
        if(bannerArr.count == 0)
        {
            print("99999999 **********")
            Api.SystemGetAPPSlide {[weak self] (arr) in
                self?.bannerArr = arr
            }
        }
        
        //banner.start()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //banner.cancel()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
}

