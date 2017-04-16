//
//  Dictionary.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

extension Dictionary {
    
    func toJson() -> String
    {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("无法解析出JSONString")
            return ""
        }
        
        do{
            if  let data = try? JSONSerialization.data(withJSONObject: self, options: [])
            {
                if let JSONString = String(data:data as Data,encoding: String.Encoding.utf8)
                {
                    return JSONString
                }
                else
                {
                    return ""
                }
                
            }
            
        }
        catch
        {
            return ""
        }
        
        return ""
    }

}
