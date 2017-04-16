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
    
    

}
