//
//  ScoreViewController.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/25/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ScoreViewController: UIViewController {
    
       
    @IBAction func reset(sender: UIButton) {
        
         UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    var player:AVAudioPlayer?  //音声を制御するための変数

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}