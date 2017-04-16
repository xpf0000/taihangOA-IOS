//
//  datePicker.swift
//  OA
//
//  Created by X on 15/5/5.
//  Copyright (c) 2015年 OA. All rights reserved.
//

import Foundation
import UIKit

typealias DatePickerBlock = (String?)->Void

class DatePicker:UIView
{
 
    let swidth = UIScreen.main.bounds.size.width
    let sheight = UIScreen.main.bounds.size.height
    
    let datePicker=UIDatePicker()
    var block:DatePickerBlock?
    var dateFormat:String = ""
    var minDate:Date?
    var maxDate:Date?
    //type 0 日期 1 时间
    
    func block(_ block: @escaping DatePickerBlock)
    {
        self.block = block
    }
    
    init(_ type:UIDatePickerMode) {
        super.init(frame: CGRect.zero)
        
        self.frame=CGRect(x: 0, y: sheight, width: swidth, height: 316)
        self.backgroundColor=UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        datePicker.frame=CGRect(x: 0, y: 40, width: swidth, height: 276)
        
        datePicker.datePickerMode=type
        
        if(type == .time || type == .dateAndTime)
        {
            datePicker.minuteInterval = 5
        }
        
        datePicker.date=Date()
        
        self.addSubview(datePicker)
        
        let view=UIView(frame: CGRect(x: 0, y: 0, width: swidth, height: 40))
        view.backgroundColor=UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        
        let okButton=UIButton(frame: CGRect(x: swidth-50, y: 6, width: 40, height: 28))
        okButton.setTitle("确定", for: UIControlState())
        okButton.setTitleColor(UIColor.black, for: UIControlState())
        okButton.addTarget(self, action: #selector(hidden(_:)), for: UIControlEvents.touchUpInside)
        okButton.tag=5
        view.addSubview(okButton)
        
        let cButton=UIButton(frame: CGRect(x: 10, y: 6, width: 40, height: 28))
        cButton.setTitle("取消", for: UIControlState())
        cButton.setTitleColor(UIColor.black, for: UIControlState())
        cButton.addTarget(self, action: #selector(hidden(_:)), for: UIControlEvents.touchUpInside)
        cButton.tag=6
        view.addSubview(cButton)
        
        self.addSubview(view)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if(newSuperview == nil)
        {
            let frame=CGRect(x: 0, y: sheight, width: swidth, height: 316)
            self.frame = frame
        }
    }
    
    func show()
    {
        if(minDate != nil)
        {
            datePicker.minimumDate = minDate
        }
        if(maxDate != nil)
        {
            datePicker.maximumDate = maxDate
        }
        
        let frame:CGRect=CGRect(x: 0, y: sheight-316, width: swidth, height: 316)
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.frame=frame
            
            }, completion: { (finished) -> Void in
        }) 
        
    }
    
    func hidden(_ sender:UIButton)
    {
        let frame=CGRect(x: 0, y: sheight, width: swidth, height: 316)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            
            self.frame=frame
            
        }, completion: { (finished) -> Void in
            
            if(self.frame.origin.y==self.sheight)
            {
                self.removeFromSuperview()
                if(sender.tag==5)
                {
                    let date=self.datePicker.date
                    let dateFormatter:DateFormatter=DateFormatter()
                    
                    if(self.datePicker.datePickerMode == .date)
                    {
                        dateFormatter.dateFormat="yyyy-MM-dd"
                    }
                    else if(self.datePicker.datePickerMode == .time)
                    {
                        dateFormatter.dateFormat="HH:mm"
                    }
                    else if(self.datePicker.datePickerMode == .dateAndTime)
                    {
                        dateFormatter.dateFormat="yyyy-MM-dd HH:mm"
                    }
                    
                    if(self.dateFormat != "")
                    {
                        dateFormatter.dateFormat=self.dateFormat
                    }
                    
                    let dateStr=dateFormatter.string(from: date)
                    
                    if(self.block != nil)
                    {
                        self.block!(dateStr)
                    }
                    
    
                }
                
            }
            
        }) 
        
        
    }
    
    deinit
    {
        self.block = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
