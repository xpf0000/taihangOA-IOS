//
//  MainTabBar.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Hero

var UserDoLogout = false

weak var home:HomeVC? = nil
weak var daibai:DaibanVC? = nil
weak var mine:MineVC? = nil

var ismain = false

class MainTabBar: UITabBarController {

    func onLogout()
    {
        if(ismain && UserDoLogout)
        {
            NotificationCenter.default.removeObserver(self)
            let vc  = "LoginVC".VC(name: "Main")
            
            let app:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            print(app.window?.rootViewController)
            
            if(app.window?.rootViewController == self)
            {
                print("0000000000")
                app.window?.rootViewController = vc
                app.window?.makeKeyAndVisible()
            }
            else
            {
                print("11111111111111")
                app.window?.rootViewController?.dismiss(animated: false, completion: {
                    
                    app.window?.rootViewController = vc
                    app.window?.makeKeyAndVisible()
                    
                })

            }
        
            home?.dodeinit()
            daibai?.dodeinit()
            mine?.dodeinit()
            
            UserDoLogout = false
            ismain = false
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(onLogout), name: NSNotification.Name(rawValue: "logout"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainTabBar  viewWillAppear !!!!!!!")
        ismain = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MainTabBar  viewDidAppear !!!!!!!")
        onLogout()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ismain = false
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
        print("MainTabBar deinit !!!!!!!!!!")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
