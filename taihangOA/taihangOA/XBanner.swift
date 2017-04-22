//
//  XBanner.swift
//  XBanner
//
//  Created by 徐鹏飞 on 16/6/27.
//  Copyright © 2016年 XBanner. All rights reserved.
//

import UIKit

class XBannerModel:NSObject
{
    var title:String=""
    var image:Any?
    var obj:Any?
}

typealias XBannerClickBlock = (XBannerModel)->Void
typealias XBannerImageViewBlock = (String,UIImageView)->Void
typealias XBannerIndexBlock = (Int,XBannerModel)->Void

class XBanner: UICollectionView ,UICollectionViewDelegate,UICollectionViewDataSource
{

    let flowLayout = UICollectionViewFlowLayout()
    private let BannerQueue = DispatchQueue(label: "com.X.BannerQueue")

    fileprivate var clickBlock:XBannerClickBlock?
    fileprivate var indexBlock:XBannerIndexBlock?
    fileprivate var imageViewBlock:XBannerImageViewBlock?
    
    fileprivate var timer:DispatchSourceTimer?
        
    
    var scrollInterval = 0.0
    {
        didSet
        {
                if bannerArr.count > 1
                {
                    start()
                }
        }
    }
    
    var scrollleftToRight = false
        {
            didSet
            {
                if bannerArr.count > 1 && scrollInterval  > 0
                {
                    start()
                }

        }
    }
    
    func onClick(_ b:@escaping XBannerClickBlock)->XBanner
    {
        clickBlock = b
        return self
    }
    
    func onIndexChange(_ b:@escaping XBannerIndexBlock)->XBanner
    {
        indexBlock = b
        return self
    }
    
    func onImageView(_ b:@escaping XBannerImageViewBlock)->XBanner
    {
        imageViewBlock = b
        return self
    }
    
    
    var bannerArr:[XBannerModel]=[]
    {
        didSet
        {
            flowLayout.itemSize = CGSize(width: 1, height: 1)
            layoutIfNeeded()
            setNeedsLayout()
            
            if bannerArr.count > 1 && scrollInterval > 0
            {
                self.start()
            }
            else
            {
                self.cancel()
            }
        }
    }
    
    var selectIndex = 0
    {
        didSet
        {
            if bannerArr.count <= 1 || selectIndex < 0 || selectIndex >= bannerArr.count  {return}
            
            let old = index

            if old == bannerArr.count-1 && selectIndex == 0
            {
                scrollToItem(at: IndexPath.init(row: selectIndex+2+bannerArr.count, section: 0), at: .left, animated: true)
                
                return
            }
            
            if old == 0 && selectIndex == bannerArr.count-1
            {
                scrollToItem(at: IndexPath.init(row: 1, section: 0), at: .left, animated: true)
                
                return
            }
  
            scrollToItem(at: IndexPath.init(row: selectIndex+2, section: 0), at: .left, animated: true)
        }
    }
    
    fileprivate var index:Int = 0
    {
        didSet
        {
            if bannerArr.count > 1
            {
                indexBlock?(index,bannerArr[index])
            }
            
        }
    }
    
    func initBanner()
    {
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0.0
        flowLayout.minimumInteritemSpacing=0.0
        flowLayout.itemSize = CGSize(width: frame.size.width == 0 ? 1 : frame.size.width, height: frame.size.height == 0 ? 1 : frame.size.height)
        collectionViewLayout = flowLayout

        isPagingEnabled = true
        layer.masksToBounds=true
        clipsToBounds = true
        
        backgroundColor = UIColor.white
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "XBannerCell")
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        delegate = self
        dataSource = self
        
    }
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initBanner()
        
    }
    
    init()
    {
        super.init(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: flowLayout)
        
        initBanner()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initBanner()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if flowLayout.itemSize.width != frame.size.width || flowLayout.itemSize.height != frame.size.height
        {
            timer?.suspend()

            flowLayout.itemSize = CGSize(width: frame.size.width, height: frame.size.height)
            reloadData()
            
            let row:CGFloat = bannerArr.count == 1 ? 0 : 2
            let w:CGFloat = (row*row+CGFloat(bannerArr.count))*frame.size.width
            
            let r = (row == 0 ? 0 :  2+CGFloat(index))

            contentOffset.x = frame.size.width * r
            
            contentSize = CGSize(width: w, height: 0)
            
            if timer != nil{
                let delayInSeconds:Double=1.0
                let popTime:DispatchTime=DispatchTime.now() + Double(Int64(delayInSeconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                
                DispatchQueue.main.asyncAfter(deadline: popTime,execute: {
                    
                    self.timer?.resume()
                    self.isRunning = true
                })
                
            }
            
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if bannerArr.count == 0
        {
            return 0
        }
        else if bannerArr.count == 1
        {
            return 1
        }
        else
        {
            return bannerArr.count+4
        }
        
    }
    
    func getTrueIndex(_ row:Int)->Int
    {
        var i = 0
        if bannerArr.count > 1
        {
            switch row
            {
            case 0:
                i = bannerArr.count-2
                
            case 1:
                i = bannerArr.count-1
                
            case bannerArr.count+2:
                i = 0
                
            case bannerArr.count+3:
                i = 1
                
            default:
                i = row - 2
            }
            
        }
        
        return i
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XBannerCell", for: indexPath)
        
        for item in cell.contentView.subviews
        {
            item.removeFromSuperview()
        }
        
        var img:UIView!
        var o:Any!
        let i = getTrueIndex(indexPath.row)
        
        o = bannerArr[i].image
        
        if let image = o as? String
        {
            img = UIImageView()
            
            if let filePath=Bundle.main.path(forResource: image, ofType:"")
            {
                if Foundation.FileManager.default.fileExists(atPath: filePath)
                {
                    (img as! UIImageView).image = UIImage(contentsOfFile: filePath)
                }
            }
            else
            {
                //网络图片下载
                imageViewBlock?(image,img as! UIImageView)
            }
            
        }
        
        if let  image = o as? UIImage
        {
            img = UIImageView()
            (img as! UIImageView).image = image
        }
        
        if let  image = o as? UIView
        {
            img = image
        }

        img.frame = CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height)

        cell.contentView.addSubview(img)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let i = getTrueIndex(indexPath.row)
        let o = bannerArr[i]
        clickBlock?(o)
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if !scrollView.isScrollEnabled || bannerArr.count == 0{return}

        if(scrollView.contentOffset.x <= frame.size.width )
        {
            scrollView.contentOffset.x=CGFloat(1+bannerArr.count)*frame.size.width
        }
        
        if(scrollView.contentOffset.x >= frame.size.width*CGFloat(bannerArr.count+2))
        {
            scrollView.contentOffset.x=CGFloat(2)*frame.size.width
        }
        
            var nowIndex = Int(round(scrollView.contentOffset.x / frame.size.width)) - 2

            nowIndex = nowIndex < 0 ? bannerArr.count-1 : nowIndex
            nowIndex = nowIndex >= bannerArr.count ?  0 : nowIndex
        
            if(nowIndex != index)
            {
               self.index = nowIndex
            }

    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
   
        if Int(scrollView.contentOffset.x) % Int(frame.size.width) != 0
        {
            let x = round(scrollView.contentOffset.x / frame.size.width)
            
            scrollView.contentOffset.x = frame.size.width * x

        }
        
    }
    
    var isRunning = false
    
    func cancel()
    {
        print("cancel ##########  000000")
        
        if(isRunning)
        {
            timer?.cancel()
            timer = nil
            isRunning = false
        }
        
        print("cancel ##########  111111")
    }
    
    func start()
    {
        
        self.cancel()
        
        print("start ##########  000000")
        
        if self.scrollInterval == 0 {return}
        // 获得队列
        let queue = DispatchQueue.global(qos: .default)
        
        // 创建一个定时器(dispatch_source_t本质还是个OC对象)
        
        //let rv = UInt(arc4random_uniform(99999))
        timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        
        //延迟多久执行
        let start = DispatchTime.now() + scrollInterval
        
        //其中的dispatch_source_set_timer的最后一个参数，是最后一个参数（leeway），它告诉系统我们需要计时器触发的精准程度。所有的计时器都不会保证100%精准，这个参数用来告诉系统你希望系统保证精准的努力程度。如果你希望一个计时器每5秒触发一次，并且越准越好，那么你传递0为参数。另外，如果是一个周期性任务，比如检查email，那么你会希望每10分钟检查一次，但是不用那么精准。所以你可以传入60，告诉系统60秒的误差是可接受的。他的意义在于降低资源消耗。
        
        timer?.scheduleRepeating(deadline: start, interval: .seconds(Int(scrollInterval)), leeway: .seconds(0))
        
        //执行事件 有次数的话 完成就自动停止
        timer?.setEventHandler {[weak self]()->Void in
            if self == nil {return}
            
            var i = self!.index
            
            if self!.scrollleftToRight == true
            {
                i  -= 1
            }
            else
            {
                i += 1
            }
            
            i = i < 0 ? self!.bannerArr.count-1 : i
            i = i >= self!.bannerArr.count ?  0 : i
            
            DispatchQueue.main.async {
                self?.selectIndex = i
            }
            
            print("banner index is changed !!!!!!!!!")
            
        }
        
        timer?.resume()
        isRunning = true
        print("start ##########  111111")
        
    }

}
