//
//  ScoreViewController.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/25/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//

import Foundation
import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
   
    
    
    let ud = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //空の配列を用意
        var scores: [Float] = []
        
        //前回の保存内容があるかどうかを判定
        if((ud.objectForKey("score")) != nil){
            
            //objectsを配列として確定させ、前回の保存内容を格納
            let objects = ud.objectForKey("score") as? NSArray
            
            //各名前を格納するための変数を宣言
            var score:AnyObject
            
            //前回の保存内容が格納された配列の中身を一つずつ取り出す
            for score in objects!{
                //配列に追加していく
                scores.append(score as! Float)
            }
            
         first.text = String(stringInterpolationSegment: scores[0])
         second.text = String(stringInterpolationSegment: scores[1])
         third.text = String(stringInterpolationSegment: scores[2])
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}