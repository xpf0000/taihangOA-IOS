//
//  Api.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias ApiBlock<T> = (T)->Void

class Api: NSObject {
    
    static let BaseUrl  = "http://apioa.sssvip.net/Public/taihangoa/?service="
    static let Pagesize = 10
    
    class func APPGetAPPLanuch(block:@escaping ApiBlock<LanchModel>)
    {
        let url = BaseUrl+"APP.GetAPPLanuch"
        print(url)
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                let model = LanchModel.parse(json: json["data"]["info"], replace: nil)
                
                print(model)
                
                block(model)
            
            case .failure(let error):
                print(error)
            }
        }
    }
    
    class func UserHeadEdit(data:[String:Any],block:@escaping ApiBlock<String>)
    {
     
        let url = BaseUrl+"User.headEdit"
        
        Alamofire.upload(multipartFormData: { (body) in
            
            for (key,value) in data
            {
                if let str = value as? String
                {
                    body.append(str.data(using: String.Encoding.utf8)!, withName: key)
                }
                
                if let d = value as? Data
                {
                    body.append(d, withName: "file", fileName: key, mimeType: "image/jpeg")
                }

            }

        }, to: url) { (res) in
            
            switch res {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
                        
                        let json = JSON(value)
                        
                        block(json["data"]["msg"].stringValue)
                        
                    case .failure(let error):
                       
                        debugPrint(error)
                        
                        block("")
                        
                    }
                    
                    debugPrint(response)
                    
                    
                }
            case .failure(let encodingError):
                print(encodingError)
                block("")
            }
            
        }
        
        
        print(url)
        
    }
    
    
    
    class func UserChecktoken(block:@escaping ApiBlock<Bool>)
    {
        
        if(DataCache.Share.User.token == "" || DataCache.Share.User.id == "")
        {
            return
        }
        
        let url = BaseUrl+"User.Checktoken&uid=\(DataCache.Share.User.id)&mobile=\(DataCache.Share.User.account)&token=\(DataCache.Share.User.token)"

        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                if let code = json["data"]["code"].int
                {
                    if code == 1
                    {
                        block(false)
                    }
                }
                
                block(true)
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    

}
