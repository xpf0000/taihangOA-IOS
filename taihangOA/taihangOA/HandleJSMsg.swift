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
            //EventBus.getDefault().post(new MyEventBus("logout"));
        }
        else
        {
            Hero.shared.setDefaultAnimationForNextTransition(.pull(direction: .right))
            Hero.shared.setContainerColorForNextTransition(.lightGray)
            
            vc.hero_dismissViewController()
            
            //vc.hero_unwindToRootViewController()
            //vc.pop()
        }
        
    }
    else if(type == 2)  //登录成功
    {
    if(msg == "登录成功")
    {
    
        let user = UserModel.parse(json: obj["info"], replace: nil)
        DataCache.Share.User = user
        DataCache.Share.User.save()
        
        let tvc = "MainTabBar".VC(name: "Main")
        vc.show(tvc, sender: nil)

        
        //APPDataCache.User.registNotice();
    
//    Intent Intent = new Intent();
//    Intent.setClass(vc, MainActivity.class);
//    vc.startActivity(Intent);
//    vc.pop()
    
    }
    if(msg ==  "退出登录")
    {
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "logout")))
    }
    
    }
    else if(type == 3)  //时间日期选择
    {
        //EventBus.getDefault().post(new MyEventBus("showTimePicker"));
    }
    else if(type == 4)  //地图选择
    {
//    Intent Intent = new Intent();
//    Intent.setClass(vc, MapVC.class);
//    vc.startActivity(Intent);
//    
//    ((XHtmlVC)vc).setMapFlag(obj.getString("flag"));
    
    }
    else if(type == 5)  //地图选择
    {
    if(msg ==  "车辆申请添加成功")
    {
        vc.pop()
    }
    
        //EventBus.getDefault().post(new MyEventBus("AddCarTaskSuccess"));
    }
    else if(type == 6)  //物品选择完成
    {
//    JSONArray arr = obj.getJSONArray("info");
//    XNotificationCenter.getInstance().postNotice("ResChoose",arr);
//    vc.pop()
    }
    else if(type == 7)  //物品申请添加成功
    {
        if(msg ==  "物品申请添加成功")
        {
            vc.pop()
        }
        //EventBus.getDefault().post(new MyEventBus("AddResTaskSuccess"));
    }
    else if(type == 8)  //待办事项操作成功
    {
        //EventBus.getDefault().post(new MyEventBus("DaibanActionSuccess"));
    }
    else if(type == 9)  //待办人选择完成
    {
//    JSONObject arr = obj.getJSONObject("info");
//    XNotificationCenter.getInstance().postNotice("DaibanChoose",arr);
//    vc.pop()
    }
    else if(type == 10)  //物品申请添加成功
    {
        if(msg ==  "督查督办添加成功")
        {
            vc.pop()
        }
        //EventBus.getDefault().post(new MyEventBus("AddOverseerTaskSuccess"));
    }
    
    else if(type == 11)  //用户头像上传
    {
        //EventBus.getDefault().post(new MyEventBus("UserHeadImageEdit"));
    }
    
    else if(type == 12)  //待办事项总数
    {
//        int count = obj.getInteger("info");
//        XNotificationCenter.getInstance().postNotice("DaibanCount",count);
    }
    
    else if(type == 13)  //用户手机号更新成功
    {
        //EventBus.getDefault().post(new MyEventBus("UserUpdateMobile"));
    }
    
    else if(type == 14)  //版本升级
    {
        //EventBus.getDefault().post(new MyEventBus("CheckVersion"));
    }
    
    }
    
}
