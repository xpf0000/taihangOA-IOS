//
//  AppDelegate.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

var mapManager:BMKMapManager?
var mapStarted = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {

    var window: UIWindow?

    func onMessageReceived(_ notification:Notification)
    {
        if let message = notification.object as? CCPSysMessage
        {
            let title = String.init(data: message.title, encoding: String.Encoding.utf8)
            
            let body = String.init(data: message.body, encoding: String.Encoding.utf8)
            
            print("Receive message title: \(title) | content: \(body)")
            
            if let str = title,let content = body
            {
                if str == "账号在其它设备已登录"
                {
                    if(DataCache.Share.User.token != "" && DataCache.Share.User.token != content)
                    {
                        let alert = UIAlertView(title: "提醒", message: "您的账户已在其他设备登录", delegate: self, cancelButtonTitle: "确定")
                        alert.show()
                    }
  
                }
                else
                {
                    NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "NewDaiban")))
                    let alert = UIAlertView(title: "提醒", message: title, delegate: nil, cancelButtonTitle: "确定")
                    alert.show()
                }
            }
            
            
        }
        
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        DataCache.Share.User.unRegistNotice()
        DataCache.Share.User.reset();
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "logout")))
        
    }
    
    
    func initCloudPush()
    {
        
        CloudPushSDK.asyncInit("23744972", appSecret: "6295ae0f5198f3795b85d23d531e7ad4") { (res) in
            
            if let r = res
            {
                if(r.success)
                {
                    print("CloudPushSDK.asyncInit success !!!!!!!!!!!!")
                }
                else
                {
                    print(r.error ?? "阿里云注册失败")
                }
            }
            else
            {
                print("阿里云注册失败")
            }
            
        }
        
        CloudPushSDK.turnOnDebug()
    }

    
    func RegistPushNotice()
    {
        let settings:UIUserNotificationSettings=UIUserNotificationSettings(types: [.alert,.sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
        UIApplication.shared.registerForRemoteNotifications()
    }

    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        initLocalHtml()
        
        RegistPushNotice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(onMessageReceived(_:)), name: NSNotification.Name(rawValue: "CCPDidReceiveMessageNotification"), object: nil)
        
        initCloudPush()
        
        mapManager = BMKMapManager()
        if let res = mapManager?.start("uzMVl09tmkeDQfLzI6d2Y1XlaVX0CmVu", generalDelegate: nil)
        {
            if(!res)
            {
                print("百度地图加载失败")
                mapStarted = false
            }
            else
            {
                mapStarted = true
            }

        }
        
        //CloudPushSDK.handleLaunching(launchOptions)
        CloudPushSDK.sendNotificationAck(launchOptions)
        return true
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        CloudPushSDK.registerDevice(deviceToken) { (res) in
            
            if let r = res
            {
                if(r.success)
                {
                    print("阿里云注册成功 Token: \(deviceToken.description)")
                }
                else
                {
                    print(r.error ?? "阿里云注册失败")
                }
            }
            else
            {
                print("阿里云注册失败")
            }
            
        }

        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("阿里云注册失败 error: \(error)")
        
    }

    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        print("收到推送: \(userInfo)")
        
        CloudPushSDK.sendNotificationAck(userInfo)
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.\
        
        print("applicationWillEnterForeground !!!!!!!!!")
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    
        print("applicationDidBecomeActive !!!!!!!!!")
        
        Api.UserChecktoken { (res) in
            
            if(!res)
            {
                DataCache.Share.User.unRegistNotice()
                DataCache.Share.User.reset();
                
                let alert = UIAlertView(title: "提醒", message: "您的账户已在其他设备登录", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
                
                NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "logout")))
                
            }
            
        }
    
    
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    func initLocalHtml()
    {
        print("-----------")
        
        let fm = Foundation.FileManager.default
        let tmpDirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("www")
        
        if !fm.fileExists(atPath: tmpDirURL.path)
        {
            do
            {
                let _ = try? fm.createDirectory(at: tmpDirURL, withIntermediateDirectories: true, attributes: nil)
                
                let _ = try? SSZipArchive.unzipFileAtPath(path: "oa.zip".path(), toDestination: tmpDirURL.path, overwrite: true, password: nil, delegate: nil)
                
                print("解压缩成功 !!!!!!!!!")
            }
            catch
            {
                print("解压失败 !!!!!!!!!")
                XAlertView.show("存储空间不足,请清理后再次使用")
    
            }
            
            
        }
        else{
            do
            {
                let _ = try? SSZipArchive.unzipFileAtPath(path: "citytest.zip".path(), toDestination: tmpDirURL.path, overwrite: true, password: nil, delegate: nil)
                
                print("解压缩成功 !!!!!!!!!")
            }
            catch
            {
                print("解压失败 !!!!!!!!!")
                XAlertView.show("存储空间不足,请清理后再次使用")
            }
            
        }
        
        
        
        
        
    }

    


}

