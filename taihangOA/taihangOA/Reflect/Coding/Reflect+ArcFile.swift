//
//  String+ArcFile.swift
//  Reflect
//
//  Created by 成林 on 15/8/23.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

import Foundation


extension Reflect{
    
    class func save(obj: AnyObject! , name: String!) -> String{
        
        if obj is [AnyObject]{assert(name != nil, "[Charlin Feng]: Name can't be empty when you Archive an array!")}
        
        let data = obj ?? self.init()
        
        let path = pathWithName(obj: data, name: name)
        
        if obj == nil
        {
            do
            {
                try Foundation.FileManager.default.removeItem(atPath: path)
            }
            catch
            {
                //print(name+" save fail !!!")
            }
            
        }
        else
        {
            NSKeyedArchiver.archiveRootObject(data, toFile: path)
        }
        
        
        return path
    }
    
    class func read(name: String!) -> AnyObject?{
        
        let path = pathWithName(obj: self.init(), name: name)
        let obj = NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject
        
        if(obj is NSNull)
        {
            return nil
        }
        
        return obj
    }
    
    class func delete(name: String!){save(obj: nil, name: name)}
    
    
    static func pathWithName(obj: AnyObject, name: String!) -> String{
        
        let fileName = name ?? Mirror(reflecting: obj).description
        
        let path = ArcFile.cachesFolder! + "/" + fileName + ".arc"
        
        return path
    }
    
    
    class ArcFile {
        
        static var cachesFolder: String? {return NSSearchPathForDirectoriesInDomains(Foundation.FileManager.SearchPathDirectory.cachesDirectory, Foundation.FileManager.SearchPathDomainMask.userDomainMask, true).last}
    }
    
    func excludedKey() -> [String]? {return nil}
}
