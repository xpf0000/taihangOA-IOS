//
//  UIColor.swift
//  OA
//
//  Created by X on 15/5/3.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit
extension UIColor
{
    func image()->UIImage{
        
        let rect=CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(self.cgColor);
        context!.fill(rect);
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return theImage!

    }
}
