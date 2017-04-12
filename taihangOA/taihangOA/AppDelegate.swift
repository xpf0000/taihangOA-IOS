//
//  AppDelegate.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        initLocalHtml()
        
        return true
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
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

