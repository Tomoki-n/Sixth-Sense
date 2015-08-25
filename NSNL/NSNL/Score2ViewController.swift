//
//  Score2ViewController.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/25/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//


import Foundation
import UIKit

class Score2ViewController: UIViewController {
    
    
    @IBOutlet weak var time: UILabel!
    let ud = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        time.text = ""
        var min:Int = Int(appDelegate.cnt) / 60
        var sec:Int = Int(appDelegate.cnt) % 60
        
        
        time.text = String(min) + "min" + String(sec) + "sec"
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}