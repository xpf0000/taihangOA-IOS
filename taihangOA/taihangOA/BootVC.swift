//
//  BootVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/12.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit
import Hero
import Kingfisher

class BootVC: UIViewController {

    // 在global线程里创建一个时间源
    let codeTimer = DispatchSource.makeTimerSource(queue:      DispatchQueue.global())
    
    @IBOutlet weak var adimage: UIImageView!
    
    @IBAction func click(_ sender: UIButton) {
    
        codeTimer.cancel()
        DispatchQueue.main.async {
            self.tonext()
        }
        
        
    }
    
    func tonext()
    {
        if(DataCache.Share.User.id == "")
        {
            let vc  = "LoginVC".VC(name: "Main")
            self.present(vc, animated: true, completion: nil)
        }
        else
        {
            let vc  = "MainTabBar".VC(name: "Main")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func showAD()
    {
        print(DataCache.Share.Lanch)
        if(DataCache.Share.Lanch.url != "")
        {
            let url = URL(string: DataCache.Share.Lanch.url)
            adimage.kf.setImage(with:url)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Api.APPGetAPPLanuch { [weak self](model) in
            DataCache.Share.Lanch = model
            self?.showAD()
        }
        
        
        // 定义需要计时的时间
        var timeCount = 3
        
        // 设定这个时间源是每秒循环一次，立即开始
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        // 设定时间源的触发事件
        codeTimer.setEventHandler(handler: {[weak self] in
            // 每秒计时一次
            timeCount = timeCount - 1
            // 时间到了取消时间源
            if timeCount <= 0 {
                self?.codeTimer.cancel()
                DispatchQueue.main.async {
                    self?.tonext()
                }
            }
        })
        // 启动时间源
        codeTimer.resume()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    
    }
    
}
