//
//  ViewController.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/20/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController ,CLLocationManagerDelegate{
    
    var lm: CLLocationManager! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.


        lm = CLLocationManager()
        // 位置情報を取るよう設定
        // ※ 初回は確認ダイアログ表示
        lm.requestAlwaysAuthorization()
        lm.delegate = self
        lm.startUpdatingHeading() // コンパス更新機能起動
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }

    // コンパスの値を受信
    func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading) {
    
               var heading:CLLocationDirection = newHeading.magneticHeading
        println("result : \(heading)")
        
        
    }
    
    
    
}

