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

class MainTabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector:#selector(onLogout), name: NSNotification.Name(rawValue: "logout"), object: nil)
    
        
    }
    
    func onLogout()
    {
        UserDoLogout = true
        let vc  = "LoginVC".VC(name: "Main")
        self.present(vc, animated: true) { 
            self.hero_replaceViewController(with: vc)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print("MainTabBar  viewWillAppear !!!!!!!")
        
        if(UserDoLogout)
        {
            onLogout()
            UserDoLogout = false
        }
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
