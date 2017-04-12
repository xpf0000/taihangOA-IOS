	//
//  String.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/11.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

    extension String {
        
        //分割字符
        func split(_ s:String)->[String]{
            if s.isEmpty{
                var x=[String]()
                for y in self.characters{
                    x.append(String(y))
                }
                return x
            }
            return self.components(separatedBy: s)
        }

        
        
        /// String使用下标截取字符串
        /// 例: "示例字符串"[0..<2] 结果是 "示例"
        subscript (r: Range<Int>) -> String {
            get {
                let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
                let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
                
                return self[startIndex..<endIndex]
            }
        }
        
    
        func color() -> UIColor{
            
            // 存储转换后的数值
            var red:UInt32 = 0, green:UInt32 = 0, blue:UInt32 = 0
            
            // 分别转换进行转换
            Scanner(string: self[0..<2]).scanHexInt32(&red)
            
            Scanner(string: self[2..<4]).scanHexInt32(&green)
            
            Scanner(string: self[4..<6]).scanHexInt32(&blue)
            
            return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1.0)
            
        }
        
        
        func path()->String
        {
            var str:String?
            str=Bundle.main.path(forResource: self, ofType: nil)
            str=(str==nil) ? "" : str
            return str!
        }

        func url()->URL?
        {
            if(FileManager.default.fileExists(atPath: self))
            {
                return URL(fileURLWithPath: self)
            }
            
            return URL(string: self)
            
        }
        
        func urlRequest() -> URLRequest?
        {
            let str = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            
            if let u = str?.url()
            {
                return URLRequest(url: u)
            }
            
            return nil
        }
        
        
        //是否包含字符串
        func has(_ s:String)->Bool{
            if (self.range(of: s) != nil) {
                return true
            }else{
                return false
            }
        }
        //是否包含前缀
        func hasBegin(_ s:String)->Bool{
            if self.hasPrefix(s) {
                return true
            }else{
                return false
            }
        }
        //是否包含后缀
        func hasEnd(_ s:String)->Bool{
            if self.hasSuffix(s) {
                return true
            }else{
                return false
            }
        }
        
        
        func VC(name:String)->UIViewController
        {
            let board:UIStoryboard=UIStoryboard(name: name, bundle: nil)
            return board.instantiateViewController(withIdentifier: self)
        }

        
        func image()->UIImage?
        {
            var image:UIImage?
            image = UIImage(contentsOfFile: self.path())
            
            if(image != nil)
            {
                return image
            }
            
            image = UIImage(contentsOfFile: self)
            
            if(image != nil)
            {
                return image
            }

            return image
        }


        
    }
