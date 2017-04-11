
import Foundation
import UIKit

typealias XAlertViewBlock = ()->Void

class XAlertView:UIView
{
    
    let SW=UIScreen.main.bounds.size.width
    let SH=UIScreen.main.bounds.size.height
    
    var message:String=""
    var visualEffectView:UIView?
    let label=UILabel()
    var block:XAlertViewBlock?
    
    class func show(_ str: String)
    {
        show(str, block: nil)
    }
    
    class func show(_ str: String, block: XAlertViewBlock?)
    {
        let view = XAlertView(msg: str)
        view.block = block
        UIApplication.shared.keyWindow?.addSubview(view)
        
    }
    
    init(msg:String)
    {
        super.init(frame: CGRect(x: 0, y: 0, width: SW, height: SH))
        self.message=msg
        self.alpha = 0.0
        self.isUserInteractionEnabled=true
        self.creatView()
    }
    
    func creatView()
    {
        self.backgroundColor=UIColor(white: 0.0, alpha: 0.35)
        
       visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.extraLight)) as UIVisualEffectView
        visualEffectView!.frame = CGRect(x: 100, y: 100, width: SW*0.7, height: SW*0.7*0.44)
        visualEffectView!.center=CGPoint(x: SW/2.0, y: SH/2.0-32)
        visualEffectView!.contentMode=UIViewContentMode.center
        
        visualEffectView!.layer.masksToBounds=true
        visualEffectView!.layer.cornerRadius=5.0
        self.addSubview(visualEffectView!)
        
        label.frame=CGRect(x: 100, y: 100, width: SW*0.6, height: SW*0.6*0.44)
        label.center=CGPoint(x: SW/2.0, y: SH/2.0-32)
        label.numberOfLines=0
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text=message
        label.textAlignment=NSTextAlignment.center
        label.backgroundColor=UIColor.clear
        label.alpha=0.0
        self.addSubview(label)
        
    }
    
    func animateAppearance()
    {
        
        self.visualEffectView?.alertAnimation(0.3, delegate: nil)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
            self.alpha = 1.0
            self.label.alpha=0.6
            
        }) { (finished) -> Void in
            if(finished)
            {
                UIView.animate(withDuration: 0.1, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                    
                    self.label.alpha=1.0
                }) { (finished) -> Void in
                    
                    if(finished)
                    {
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(1.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
                            
                            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveLinear, animations: { () -> Void in
                                self.alpha=0.0
                            }) { (finished) -> Void in
                                
                                if(finished)
                                {
                                    self.block?()
                                    self.removeFromSuperview()
                                }
                            }
                            
                            
                        });
                    }
                }
            }
            
        }
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if newSuperview != nil
        {
            self.animateAppearance()
        }
        
    }
    
    
    deinit
    {
        self.visualEffectView=nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
