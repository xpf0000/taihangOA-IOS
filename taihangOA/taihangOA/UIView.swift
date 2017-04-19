//
//  UIView.swift
//  swiftTest
//
//  Created by X on 15/3/14.
//  Copyright (c) 2015年 swiftTest. All rights reserved.
//

import Foundation
import UIKit



extension UIView
{
    
    func endEdit()
    {
        self.endEditing(true)
    }
    
    
    func addEndButton()
    {
        
        let swidth = UIScreen.main.bounds.size.width
        
        // 键盘添加一下Done按钮
        let topView : UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: swidth, height: 38))
        
        topView.layer.shadowColor = UIColor.clear.cgColor
        topView.layer.masksToBounds = true
        topView.isTranslucent = true
        
        let btn = UIButton(type: .custom)
        
        btn.setTitleColor("007AFF".color(), for: UIControlState())
        btn.setTitle("完成", for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        
        btn.frame = CGRect(x: swidth-60, y: 0, width: 48, height: 38)
        topView.addSubview(btn)
        
        btn.click {[weak self] (b) in
            
            self?.endEdit()
        }
        
        self.setValue(topView, forKey: "inputAccessoryView")
    }

    
    
    var rootView:UIView{
        
        var rootview=self
        while ((rootview.superview) != nil) {
            
            if (rootview.superview is UIWindow) {
                
                break
                
            }
            
            rootview = rootview.superview!
            
        }
        
        return rootview
    }
    
    var viewController:UIViewController?
        {
            var next:UIView = self.superview == nil ? self : self.superview!
            
            while(!(next is UIWindow))
            {
                let nextResponder:UIResponder=next.next!
                if (nextResponder is UIViewController)
                {
                    return nextResponder as? UIViewController;
                }
                
                next=next.superview!
            }
            
            
            return nil
        }
    
    
    func removeAllSubViews()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }

    //旋转 时间 角度
    func revolve(_ time:TimeInterval,angle:CGFloat)
    {
        if(angle == 0.0)
        {
            UIView.animate(withDuration: time, animations: { () -> Void in
                self.transform=CGAffineTransform.identity
            })
        }
        else
        {
            UIView.animate(withDuration: time, animations: { () -> Void in
                self.transform=CGAffineTransform(rotationAngle: CGFloat(M_PI)*CGFloat(angle))
            })
        }
        
       

    }
    
    
    
    //抖动动画
    func shake()
    {
        // 获取到当前的View
        
        let viewLayer:CALayer = self.layer;
        
        // 获取当前View的位置
        
        let position = viewLayer.position;
        
        // 移动的两个终点位置
        
        let x = CGPoint(x: position.x + 8, y: position.y);
        
        let y = CGPoint(x: position.x - 8, y: position.y);
        
        let  animation = CABasicAnimation(keyPath: "position")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        animation.fromValue = NSValue(cgPoint: x)
        animation.toValue = NSValue(cgPoint: y)
        animation.autoreverses = true
        animation.duration = 0.05
        animation.repeatCount = 4
        viewLayer.add(animation, forKey: nil)
        
    }
    
    func alertAnimation(_ dur:TimeInterval,delegate:AnyObject?)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
  
        animation.isRemovedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.1, 0.1, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.2, 1.2, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.delegate = delegate
        self.layer.add(animation, forKey: nil)
     
    }
    
    func bounceAnimation(_ dur:TimeInterval,delegate:AnyObject?)
    {
        let  animation = CAKeyframeAnimation(keyPath: "transform")
        
        animation.duration = dur;
        
        animation.isRemovedOnCompletion = false;
        
        animation.fillMode = kCAFillModeForwards;
        
        var values : Array<AnyObject> = []
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(2.0, 2.0, 1.0)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(0.9, 0.9, 0.9)))
        values.append(NSValue(caTransform3D: CATransform3DMakeScale(1.0, 1.0, 1.0)))
        animation.values = values;
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.delegate = delegate
        self.layer.add(animation, forKey: nil)
        
    }
    
    
    static func printAllSubView(_ v:UIView)
    {
        for item in v.subviews
        {
            //print(item)
            if item.subviews.count > 0
            {
                printAllSubView(item)
            }
        }
        
    }
    
    static func findTableView(_ v:UIView)->UITableView?
    {
        if v is UITableView
        {
            return v as? UITableView
        }
        
        if v.superview != nil
        {
            return findTableView(v.superview!)
        }
        else
        {
            return nil
        }
        
    }
    
    
    
    
    
}
