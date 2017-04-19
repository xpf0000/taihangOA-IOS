//
//  MapVC.swift
//  taihangOA
//
//  Created by 徐鹏飞 on 2017/4/13.
//  Copyright © 2017年 taihangOA. All rights reserved.
//

import UIKit

class MapVC: UIViewController,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate {
    
    
    @IBOutlet weak var searchTF: UITextField!

    @IBOutlet weak var map: BMKMapView!
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dosubmit(_ sender: Any) {
        
        if(caddress == "" || cmap == nil)
        {
            XMessage.Share.show("请点击地图选择一个位置")
            return
        }
        
        if(DataCache.Share.mapFlag == "saddress")
        {
            DataCache.Share.SMap.caddress = caddress
            DataCache.Share.SMap.cmap = "\(cmap!.latitude),\(cmap!.longitude)"
        }
        else
        {
            DataCache.Share.EMap.caddress = caddress
            DataCache.Share.EMap.cmap = "\(cmap!.latitude),\(cmap!.longitude)"
        }
        
        if(DataCache.Share.EMap.cmap != "" && DataCache.Share.SMap.cmap != "")
        {
            let arr1 = DataCache.Share.EMap.cmap.split(",")
            let arr2 = DataCache.Share.SMap.cmap.split(",")
        
            let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(Double(arr1[0])!,Double(arr1[1])!));
            let point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(Double(arr2[0])!,Double(arr2[1])!));
            
            let d = BMKMetersBetweenMapPoints(point1,point2);
            
            DataCache.Share.EMap.distance = "\(d)"
            DataCache.Share.SMap.distance = "\(d)"
        }
        
        NotificationCenter.default.post(Notification.init(name: Notification.Name(rawValue: "MapSelected")))
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var clabel: UILabel!
    
    
    
    var locService:BMKLocationService?
    var annotation:BMKPointAnnotation?
    let search = BMKGeoCodeSearch()
    
    var poiname = ""
    var caddress = ""
    var cmap:CLLocationCoordinate2D?
    
    func startMapService()
    {
        if mapStarted {return}
        
        if let res = mapManager?.start("uzMVl09tmkeDQfLzI6d2Y1XlaVX0CmVu", generalDelegate: nil)
        {
            if(!res)
            {
                print("百度地图加载失败")
                mapStarted = false
            }
            else
            {
                mapStarted = true
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startMapService()
        
        map.zoomLevel = 14
        map.showsUserLocation = true
        locService = BMKLocationService()
        locService?.delegate = self
        locService?.startUserLocationService()
        search.delegate = self
        
        searchTF.addEndButton()
        
    }
    
    
    func mapView(_ mapView: BMKMapView!, onClickedMapBlank coordinate: CLLocationCoordinate2D) {
        poiname = ""
        searchPoint(pt: coordinate)
        
    }
    
    
    func searchPoint(pt:CLLocationCoordinate2D)
    {
        map.removeAnnotation(annotation)
        
        annotation = BMKPointAnnotation()
        //annotation?.coordinate = map.convert(point, toCoordinateFrom: self.view)
        annotation?.coordinate = pt
        annotation?.title = "当前选择"
        map.addAnnotation(annotation)
        
        if let g = annotation?.coordinate
        {
            let opt = BMKReverseGeoCodeOption()
            opt.reverseGeoPoint = g
            
            let res = search.reverseGeoCode(opt)
            if(!res)
            {
                print("坐标检索失败")
                
            }
            else
            {
                clabel.text = "检索中..."
                caddress = ""
                cmap = pt
            }
            
        }

    }
    
    
    func mapView(_ mapView: BMKMapView!, onClickedMapPoi mapPoi: BMKMapPoi!) {
    
        poiname = mapPoi.text
        searchPoint(pt: mapPoi.pt)
        
    }
    
    func onGetReverseGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKReverseGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        if(error.rawValue == 0)
        {
            let address = "\(result.addressDetail.province!)\(result.addressDetail.city!)\(result.addressDetail.district!)\(result.addressDetail.streetName!)\(result.addressDetail.streetNumber!)\(poiname)"
            
            clabel.text = address
            caddress = address
        }
        
    }
    
    func onGetGeoCodeResult(_ searcher: BMKGeoCodeSearch!, result: BMKGeoCodeResult!, errorCode error: BMKSearchErrorCode) {
        
        if(error.rawValue == 0)
        {
            map.removeAnnotation(annotation)
        
            annotation = BMKPointAnnotation()
            annotation?.coordinate = result.location
            annotation?.title = "当前选择"
            map.addAnnotation(annotation)
            
            map.setCenter(result.location, animated: true)
            
            cmap = result.location
            caddress = result.address
            clabel.text = caddress
            
        }
        else
        {
            clabel.text = "检索失败,请检查输入地址"
            caddress = ""
            cmap = nil
        }

        
    }
    
    func didUpdate(_ userLocation: BMKUserLocation!) {
        map.updateLocationData(userLocation)
        map.setCenter(userLocation.location.coordinate, animated: true)
        locService?.stopUserLocationService()
    }
    
    func didUpdateUserHeading(_ userLocation: BMKUserLocation!) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
            textField.endEdit()
        
        if let str = textField.text?.trim()
        {
            let option = BMKGeoCodeSearchOption()
            option.city=""
            option.address = str
            
            let res = search.geoCode(option)
            
            if(res)
            {
                clabel.text = "检索中..."
            }
            else
            {
                clabel.text = "检索失败,请检查输入地址"
            }
            
            caddress = ""
            cmap = nil
            
            
        }
        
        
        return true
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        map.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        map.delegate = nil
        search.delegate = nil
        locService?.delegate = nil
        locService?.stopUserLocationService()
    }
    

}
