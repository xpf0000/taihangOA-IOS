
import Foundation
import UIKit
import NVActivityIndicatorView

class XWaitingView:UIView
{
    var visualEffectView:UIView?
    var now=0
    var view:NVActivityIndicatorView!
    
    let SW=UIScreen.main.bounds.size.width
    let SH=UIScreen.main.bounds.size.height
    
    static let Share = XWaitingView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
    
    class func show()
    {
        UIApplication.shared.keyWindow?.addSubview(Share)
    }
    
    class func showBlack()
    {
        Share.black()
        UIApplication.shared.keyWindow?.addSubview(Share)
    }
    
    class func hide()
    {
        Share.removeFromSuperview()
    }
    
    override fileprivate init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 1.0
        self.isUserInteractionEnabled=true
        self.creatView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func creatView()
    {
        self.backgroundColor=UIColor(white: 0.0, alpha: 0.35)
        
        visualEffectView=UIView(frame: CGRect(x: 100, y: 100, width: SW*0.24, height: SW*0.24))
        visualEffectView!.center=CGPoint(x: SW/2.0, y: SH/2.0-32)
        visualEffectView!.contentMode=UIViewContentMode.center
        visualEffectView!.layer.masksToBounds=true
        visualEffectView!.layer.cornerRadius=5.0
        
        self.white()
        //        let button = UIButton(type: .Custom)
        //        button.frame = CGRectMake(0, 0, SW*0.24, SW*0.24)
        //        button.addTarget(self, action: "change", forControlEvents: UIControlEvents.TouchUpInside)
        //
        //        visualEffectView?.addSubview(button)
        
    }
    
    func white()
    {
        view?.stopAnimating()
        view?.removeFromSuperview()
        view=nil
        view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: SW*0.24, height: SW*0.24), type: .ballClipRotate, color: "21adfd".color(), padding: 0.5)
        visualEffectView?.backgroundColor=UIColor.white
        visualEffectView?.addSubview(view)
    }
    
    func black()
    {
        view?.stopAnimating()
        view?.removeFromSuperview()
        view=nil
        view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: SW*0.24, height: SW*0.24), type: .ballClipRotate, color: UIColor.white, padding: 0.5)
        visualEffectView?.backgroundColor="333749".color()
        visualEffectView?.addSubview(view)
        
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if(newSuperview != nil)
        {
            self.visualEffectView!.alpha=0.0
            self.visualEffectView!.alertAnimation(0.3, delegate: nil)
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.visualEffectView!.alpha=1.0
            })
            
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                
                self.visualEffectView!.alpha=0.0
                
                }, completion: { (finish) -> Void in
                    
                    self.visualEffectView!.removeFromSuperview()
                    if self.visualEffectView!.backgroundColor != UIColor.white
                    {
                        self.white()
                    }
                    
            })
            
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if(self.superview != nil)
        {
            UIApplication.shared.keyWindow?.addSubview(self.visualEffectView!)
            self.view.stopAnimating()
        }
        
    }
    
    
    deinit
    {
        self.visualEffectView=nil
    }
    
}
