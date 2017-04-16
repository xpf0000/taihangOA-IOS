//
//  ResModel.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/14.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class ResItemModel: Reflect {
    
    var cname = ""
    var id = ""
    var name = ""
    var cid = ""
    
}

class ResModel: Reflect {
    
    var type = ""
    var msg = ""
    var info:[ResItemModel] = []
    
}
