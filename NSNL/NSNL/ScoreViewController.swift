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
    
       
    var player:AVAudioPlayer?  //音声を制御するための変数

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
     
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
        var player:AVAudioPlayer?  //音声を制御するための変数
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent("don.mp3")
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        player = AVAudioPlayer(contentsOfURL: url, error: nil)
        // Optional Chainingを使う。
        if let thePlayer = player {
            
            thePlayer.prepareToPlay()
            thePlayer.play()
            
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}