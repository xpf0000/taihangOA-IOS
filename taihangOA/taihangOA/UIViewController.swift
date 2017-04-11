//
//  UIViewController.swift
//  OA
//
//  Created by X on 15/5/18.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{
    
    
    func checkIsLogin()->Bool
    {
//        if(DataCache.Share.userModel.uid == "")
//        {
//            if(self is XViewController)
//            {
//                (self as! XViewController).jumpAnimType=AnimatorType.default
//            }
//            
//            
//            let vc:LoginVC = "LoginVC".VC("User") as! LoginVC
//            
//            let nav:XNavigationController = XNavigationController(rootViewController: vc)
//            
//            self.present(nav, animated: true, completion: { () -> Void in
//                
//                
//            })
//            
//            return false
//        }
//        
        return true
    }
    
        
    func pop()
    {
        self.view.endEditing(true)
        
        self.navigationController?.popViewController(animated: true)
        
        if let nv = self.navigationController{
            
            if(nv.viewControllers.count > 1)
            {
                return
            }
            
        }
        
        self.dismiss(animated: true) { () -> Void in
            
        }
        
    }
    
        

}
