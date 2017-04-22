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
import SwiftyJSON
import Hero


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


class HtmlVC: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler{
    
    var webView:WKWebView?
    var url:URL?
    var html:String=""
    var baseUrl:URL?

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
        
        if webView?.canGoBack == true
        {
            webView?.goBack()
        }
    }
    
    func reload()
    {
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
    
    override func pop() {
    
        webView?.configuration.userContentController.removeScriptMessageHandler(forName: "JSHandle")
        webView?.uiDelegate=nil
        webView?.navigationDelegate=nil
        webView?.stopLoading()
        webView=nil
        
        super.pop()
    }
    
    let scriptHandle = WKUserContentController()
    var  panGR: UIPanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector:#selector(onLogout), name: NSNotification.Name(rawValue: "logout"), object: nil)

        isHeroEnabled = true
    
        panGR = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panGR)
        
        self.view.backgroundColor = UIColor.white
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
        v.backgroundColor = APPBlueColor
        self.view.addSubview(v)
        
        constrain(v) { (view) in
            view.width == (view.superview?.width)!
            view.height == sh
            view.top == (view.superview?.top)!
            view.left == (view.superview?.left)!
            
        }

    
        self.show()
        
        if("\(url)".has("car_apply.html"))
        {
            DataCache.Share.SMap.flag = "saddress"
            DataCache.Share.EMap.flag = "eaddress"
            
            NotificationCenter.default.addObserver(self, selector:#selector(onMapSelected), name: NSNotification.Name(rawValue: "MapSelected"), object: nil)
            
            datepicker.block {[weak self] (date) in
                self?.webView?.evaluateJavaScript("javascript:OnTimeSelect('"+date!+"')", completionHandler: { (res, err) in
                    print(res)
                    print(err)
                })
            }
        }
        
        if("\(String(describing: url))".has("car_list.html"))
        {
            NotificationCenter.default.addObserver(self, selector:#selector(reload), name: NSNotification.Name(rawValue: "AddCarTaskSuccess"), object: nil)
        }
        
        if("\(String(describing: url))".has("office_list.html"))
        {
            NotificationCenter.default.addObserver(self, selector:#selector(reload), name: NSNotification.Name(rawValue: "AddResTaskSuccess"), object: nil)
        }
        
        if("\(String(describing: url))".has("duban_list.html"))
        {
            NotificationCenter.default.addObserver(self, selector:#selector(reload), name: NSNotification.Name(rawValue: "AddOverseerTaskSuccess"), object: nil)
        }

        
        if("\(String(describing: url))".has("Office_apply.html"))
        {
            NotificationCenter.default.addObserver(self, selector:#selector(onResChoose), name: NSNotification.Name(rawValue: "ResChoose"), object: nil)
        }
        
        if("\(String(describing: url))".has("duban_apply.html"))
        {
            NotificationCenter.default.addObserver(self, selector:#selector(DaibanChoose), name: NSNotification.Name(rawValue: "DaibanChoose"), object: nil)
            
            datepicker.block {[weak self] (date) in
                self?.webView?.evaluateJavaScript("javascript:OnTimeSelect('"+date!+"')", completionHandler: { (res, err) in
                    print(res ?? "")
                    print(err ?? "")
                })
            }
            
        }
        
        
        if("\(String(describing: url))".has("edit_phone") || "\(String(describing: url))".has("re_phone"))
        {
            NotificationCenter.default.addObserver(self, selector:#selector(UserUpdateMobile), name: NSNotification.Name(rawValue: "UserUpdateMobile"), object: nil)
        }
        
    }
    
    func UserUpdateMobile()
    {
        hero_unwindToRootViewController()
    }
    
    func DaibanChoose()
    {
        self.webView?.evaluateJavaScript("javascript:OnDoUserChoose('"+DataCache.Share.DaibanUser.toDict().toJson()+"')", completionHandler: { (res, err) in
            print(res ?? "")
            print(err ?? "")
        })
    }
    
    func onResChoose()
    {
        self.webView?.evaluateJavaScript("javascript:OnResChoose('"+DataCache.Share.Res.toDict().toJson()+"')", completionHandler: { (res, err) in
            print(res)
            print(err)
        })

    }
    
    func onMapSelected()
    {
        var str = ""
        if(DataCache.Share.mapFlag == "saddress")
        {
            str = DataCache.Share.SMap.toDict().toJson()
        }
        else
        {
            str = DataCache.Share.EMap.toDict().toJson()
        }
        
        print(str)
        
        self.webView?.evaluateJavaScript("javascript:OnMapSelect('"+str+"')", completionHandler: { (res, err) in
            print(res)
            print(err)
        })

    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        if let str = message.body as? String
        {
            self.msgChanged(str)
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
        
        
        if("\(String(describing: url))".has("about.html"))
        {
            let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
            webView.evaluateJavaScript("javascript:OnGetVersionName('"+currentVersion+"')", completionHandler: { (res, err) in

            })
            
        }
        
        
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
    
    func onLogout()
    {
        dodeinit()
        self.hero_unwindToRootViewController()
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
        print("HtmlVC deinit !!!!!!!!!!!!!!!!")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(!NetConnected)
        {
            XMessage.Share.show("未检测到网络连接,请检查网络")
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
        Hero.shared.setContainerColorForNextTransition(.lightGray)
        
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
    
    
    enum TransitionState {
        case normal, slidingLeft, slidingRight
    }
    var state: TransitionState = .normal
    
    func pan() {
        let translateX = panGR.translation(in: nil).x
        let velocityX = panGR.velocity(in: nil).x
        let progress = translateX / 2 / UIScreen.main.bounds.size.width
        switch panGR.state {
        case .began:
            hero_dismissViewController()
        case .changed:
            Hero.shared.update(progress: Double(progress))
        default:
            let progress = (translateX + velocityX) / view.bounds.width
            if (progress < 0) == (state == .slidingLeft) && abs(progress) > 0.3 {
                Hero.shared.end()
                
                dodeinit()
                
            } else {
                Hero.shared.cancel()
            }

        }
    }

    
    
    
}
