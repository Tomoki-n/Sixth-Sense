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
    
    
    @IBAction func reset(sender: UIButton) {
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBOutlet weak var time: UILabel!
    let ud = NSUserDefaults.standardUserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
              
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}