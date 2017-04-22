//
//  UserModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class UserModel: Reflect {

    var id=""
    var account=""
    var sex=""
    var mobile=""
    var departmentid=""
    var name=""
    var avatar=""
    var user_status=""
    var token=""
    var dname=""
    
    func reset()
    {
        id=""
        account=""
        sex=""
        mobile=""
        departmentid=""
        name=""
        avatar=""
        user_status=""
        token=""
        dname=""
        save()
    }
    
    func save()
    {
        _ = UserModel.save(obj: self, name: "User")
    }
    
    func registNotice()
    {
        CloudPushSDK.removeAlias(nil) { (res) in}
        
        if id != ""
        {
            CloudPushSDK.addAlias(id, withCallback: { (res) in
                
            })
        }
    }
    
    func unRegistNotice()
    {
        CloudPushSDK.removeAlias(nil) { (res) in }
    }
    
    
    
}
