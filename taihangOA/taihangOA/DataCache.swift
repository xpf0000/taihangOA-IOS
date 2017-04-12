//
//  DataCache.swift
//  swiftTest
//
//  Created by X on 15/3/3.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit

class DataCache: NSObject {

    static let Share = DataCache()
    
    var User = UserModel()
    
    fileprivate override init() {
        super.init()
        
        if let model = UserModel.read(name: "User")
        {
           User = model as! UserModel
        }
        
}
    
    
  
    
}
