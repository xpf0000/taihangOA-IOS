//
//  HandleJSMsg.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Hero



class HandleJSMsg: NSObject {

    
    static func handle(obj:JSON, vc:UIViewController)
{
    let type = obj["type"].intValue
    let msg = obj["msg"].stringValue
    
    print(obj)
  
    if(type == 0)  //url 跳转
    {
    
        let url = obj["url"].stringValue
        let arr = url.split(".html")
        
        let base = TmpDirURL.appendingPathComponent("\(arr[0]).html")
        if let full = "\(base)\(arr[1])".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        {
            let tovc = HtmlVC()
            tovc.baseUrl = TmpDirURL
            tovc.url = URL(string: full)
            
            Hero.shared.setDefaultAnimationForNextTransition(.push(direction: .left))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            
            vc.present(tovc, animated: true, completion: nil)
        }
    
        
    }
    else if(type == 1)  //返回
    {
        
        let back = obj["back"].stringValue
        if(back != "")
        {
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "logout")))
        }
        else
        {
            Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            
            vc.hero_dismissViewController()

        }
        
    }
    else if(type == 2)  //登录成功
    {
        if(msg == "登录成功")
        {
            
            let user = UserModel.parse(json: obj["info"], replace: nil)
            DataCache.Share.User = user
            DataCache.Share.User.save()
            DataCache.Share.User.registNotice()
            let tvc = "MainTabBar".VC(name: "Main") as! MainTabBar
            tvc.selectedIndex = 0
            
            vc.hero_replaceViewController(with: tvc)

        }
        
        if(msg ==  "退出登录")
        {
            DataCache.Share.User.unRegistNotice()
            DataCache.Share.User.reset();
            NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "logout")))
        }
    
    }
    else if(type == 3)  //时间日期选择
    {

        datepicker.removeFromSuperview()
        UIApplication.shared.keyWindow?.addSubview(datepicker)
        datepicker.show()
        
    }
    else if(type == 4)  //地图选择
    {
        
        DataCache.Share.mapFlag = obj["flag"].stringValue
        
        let tvc = "MapVC".VC(name: "Main")
        
        Hero.shared.setDefaultAnimationForNextTransition(.push(direction: .left))
        Hero.shared.setContainerColorForNextTransition(.lightGray)
        
        vc.present(tvc, animated: true, completion: nil)
    }
    else if(type == 5)  //车辆申请添加成功
    {
        if(msg ==  "车辆申请添加成功")
        {
            Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            
            vc.hero_dismissViewController()
        }
    
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "AddCarTaskSuccess")))
        
    }
    else if(type == 6)  //物品选择完成
    {
        
        DataCache.Share.Res = ResModel.parse(json: obj, replace: nil)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "ResChoose")))
        
        Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
        Hero.shared.setContainerColorForNextTransition(.lightGray)
        vc.hero_dismissViewController()
        
    }
    else if(type == 7)  //物品申请添加成功
    {
        if(msg ==  "物品申请添加成功")
        {
            Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            vc.hero_dismissViewController()
        }
        
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "AddResTaskSuccess")))
        
    }
    else if(type == 8)  //待办事项操作成功
    {
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "NewDaiban")))
    }
    else if(type == 9)  //待办人选择完成
    {
        
        DataCache.Share.DaibanUser = UserModel.parse(json: obj["info"], replace: nil)
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "DaibanChoose")))
        
        Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
        Hero.shared.setContainerColorForNextTransition(.lightGray)
        vc.hero_dismissViewController()
        
    }
    else if(type == 10)  //督查督办添加成功
    {
        if(msg ==  "督查督办添加成功")
        {
            Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            vc.hero_dismissViewController()
        }
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "AddOverseerTaskSuccess")))
    }
    
    else if(type == 11)  //用户头像上传
    {
        if let v = vc as? MineVC
        {
            v.onUploadHeadPic()
        }
    }
    
    else if(type == 12)  //待办事项总数
    {
        DataCache.Share.daibanCount = obj["info"].intValue
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "DaibanCount")))
        
    }
    
    else if(type == 13)  //用户手机号更新成功
    {
        
        let user = UserModel.parse(json: obj["info"], replace: nil)
        DataCache.Share.User = user
        DataCache.Share.User.save()
        
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "UserUpdateMobile")))
    }
    
    else if(type == 14)  //版本升级
    {
        //EventBus.getDefault().post(new MyEventBus("CheckVersion"));
    }
    
    }
    
}
