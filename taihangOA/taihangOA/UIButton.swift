//
//  UIButton.swift
//  chengshi
//
//  Created by X on 16/6/11.
//  Copyright © 2016年 XSwiftTemplate. All rights reserved.
//

import UIKit

typealias XButtonBlock = (UIButton)->Void

class XButtonBlockModel: NSObject {
    
    var block:XButtonBlock?
}

private var XButtonBlockKey:CChar = 0

extension UIButton {

    fileprivate var clickBlock:XButtonBlockModel?
        {
        get
        {
            let r = objc_getAssociatedObject(self, &XButtonBlockKey) as? XButtonBlockModel
            
            return r
        }
        set {
            
            self.willChangeValue(forKey: "XButtonBlockKey")
            objc_setAssociatedObject(self, &XButtonBlockKey, newValue,
                                     .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            self.didChangeValue(forKey: "XButtonBlockKey")
            
        }
        
    }
    
    func click(_ b:  @escaping XButtonBlock)
    {
        self.clickBlock?.block = nil
        self.clickBlock = nil
        
        let m = XButtonBlockModel()
        m.block = b
        self.clickBlock=m
        
        self.removeTarget(self, action: #selector(doClick), for: .touchUpInside)
        
        self.addTarget(self, action: #selector(doClick), for: .touchUpInside)
        
    }
    
    @objc fileprivate func doClick()
    {
        clickBlock?.block?(self)
    }
    

}
