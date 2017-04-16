//
//  XMessage.swift
//  chengshi
//
//  Created by X on 15/12/18.
//  Copyright © 2015年 XSwiftTemplate. All rights reserved.
//

import UIKit
import Cartography

class XMessage: UIView {

    let swidth = UIScreen.main.bounds.size.width
    let sheight = UIScreen.main.bounds.size.height
    
    static let Share = XMessage.init(frame: CGRect.zero)
    
    var label=UILabel()
    var msg=""
        
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = "333749".color()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        
        self.label.font = UIFont.boldSystemFont(ofSize: 13.0)
        self.label.textColor = UIColor.white
        self.label.numberOfLines = 0
        self.label.textAlignment = NSTextAlignment.center
        self.label.preferredMaxLayoutWidth = swidth*0.6-60.0
        self.addSubview(self.label)
        
        
        constrain(label) { (view) in
            view.edges == inset(view.superview!.edges, 10, 30, 10, 30)
        }

    }
    
    func show(_ str:String)
    {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.label.text = str
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            
            self.alpha = 1.0
            
            }) { (finished) -> Void in
                if(finished)
                {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                        
                        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                            self.alpha=0.0
                            }) { (finished) -> Void in
                                
                                self.removeFromSuperview()
                        }
                        
                    });
                
                }
                
        }
        
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if(self.superview != nil)
        {
            constrain(self) { (view) in
                view.centerX == (view.superview?.centerX)!
                view.width == swidth*0.6
                view.height >= 50.0
                view.bottom == (view.superview?.bottom)!-100
            }
            
        }
        
    }
    


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
