//
//  JSHandle.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import JavaScriptCore

typealias JSHandleBlock = (String)->Void

class JSHandle
{
    var block:JSHandleBlock?
    
    func onMsgChange(_ b:@escaping JSHandleBlock)
    {
        block = b
    }
    
    var msg:String? = ""
    {
        didSet
        {
            if(msg != nil)
            {
                block?(msg!)
            }
            
        }
    }
    
    func jsMessage(_ message: String) {
        
        msg = message
        
    }
    
    deinit{
        print("JSHandle deinit !!!!!!!!!!!!!!!")
    }
    
}



protocol XJSExports : JSExport {
    var msg: String? { get set }
    func jsMessage(_ message: String) -> Void
}
