//
//  Reflect.swift
//  Reflect
//
//  Created by 冯成林 on 15/8/19.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation

typealias ReflectValueChangeBlock = (String,Any)->Void

class Reflect: NSObject, NSCoding{
    
    lazy var mirror: Mirror = {Mirror(reflecting: self)}()
    
    required override init(){}
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        self.init()
        
        let ignorePropertiesForCoding = self.excludedKey()
        
        self.properties { (name, type, value) -> Void in
            assert(type.check(), "[Charlin Feng]: Property '\(name)' type can not be a '\(type.realType.rawValue)' Type,Please use 'NSNumber' instead!")
            
            if(name.range(of: ".storage") != nil)
            {
                return
            }
            
            let hasValue = ignorePropertiesForCoding != nil
            
            if hasValue {
                
                let ignore = (ignorePropertiesForCoding!).contains(name)
                
                if !ignore {
                    
                    self.setValue(aDecoder.decodeObject(forKey: name), forKeyPath: name)
                }
            }else{
                
                if let saveValue = aDecoder.decodeObject(forKey: name)
                {
                    switch type.realType
                    {
                    case .String:
                        if let v = saveValue as? String
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Int:
                        if let v = saveValue as? Int
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Float:
                        if let v = saveValue as? Float
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Double:
                        if let v = saveValue as? Double
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    case .Bool:
                        if let v = saveValue as? Bool
                        {
                            self.setValue(v, forKeyPath: name)
                        }
                        
                    default:
                        self.setValue(saveValue, forKeyPath: name)
                    }
                    
                    
                }
                
                
                
            }
        }
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        let ignorePropertiesForCoding = self.excludedKey()
        
        self.properties { (name, type, value) -> Void in
            
            if(name.range(of: ".storage") != nil)
            {
                return
            }
            
            let hasValue = ignorePropertiesForCoding != nil
            
            if hasValue {
                
                let ignore = (ignorePropertiesForCoding!).contains(name)
                
                if !ignore {
                    
                    let o = value as? AnyObject
                    
                    if(o != nil)
                    {
                        aCoder.encode(o!, forKey: name)
                    }
                    else
                    {
                        if(self.value(forKeyPath: name) is NSCoding)
                        {
                            aCoder.encode(self.value(forKeyPath: name), forKey: name)
                        }
                        
                    }
                    
                }
            }else{
                
                let o = value as? AnyObject
                
                if(o != nil)
                {
                    aCoder.encode(o!, forKey: name)
                }
                else
                {
                    if(self.value(forKeyPath: name) is NSCoding)
                    {
                        aCoder.encode(self.value(forKeyPath: name), forKey: name)
                    }
                }
                
            }
            
        }
        
    }
    
    
    override func setValue(_ value: Any?, forKeyPath keyPath: String) {
        
        if(value == nil)
        {
            return
        }
        
        super.setValue(value, forKeyPath: keyPath)
        //valueChangeBlock?(keyPath,value!)
        
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        
        if(value == nil)
        {
            return
        }
        
        super.setValue(value, forKey: key)
        //valueChangeBlock?(key,value!)
        
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}



