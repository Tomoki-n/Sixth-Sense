//
//  GameViewController.swift
//  ee
//
//  Created by itsuki on 2015/08/20.
//  Copyright (c) 2015年 itsuki. All rights reserved.
//
import Foundation
import UIKit
import MultipeerConnectivity
import CoreLocation
import SpriteKit


extension SKNode {
    class func unarchiveFromFile(file : String) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as! GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}

class GameViewController: UIViewController, MCBrowserViewControllerDelegate,MCSessionDelegate ,CLLocationManagerDelegate  {

    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID! = nil
    var getid :Int = 0
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "onUpdate:", userInfo: nil, repeats: true)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = skView.frame.size
            
            skView.presentScene(scene)

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if (getid == 0){
            getid = 1
            self.presentViewController(self.browser, animated: true, completion: nil)
        }
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func sendMes(values: String){
        
        var msg = values.dataUsingEncoding(NSUTF8StringEncoding,allowLossyConversion: false)
        
        var error : NSError?
        
        self.session.sendData(msg, toPeers: self.session.connectedPeers, withMode: MCSessionSendDataMode.Unreliable, error: &error)
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
    }
    
    
    func Receive(Getmsg :String){
        
        
        //声をだす
        
    
    
    
    
    }
    
    
    
    
    
    
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
            appDelegate.controller = self
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
            appDelegate.controller = self
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                
                println(msg)
                if(msg=="FIRSTPOS 0"||msg=="FIRSTPOS 1"||msg=="FIRSTPOS 2"||msg=="FIRSTPOS 3"){
                    self.appDelegate.FirstPOS = msg
                    self.appDelegate.firstflag = true
                }
                else if (msg=="0"||msg=="1"||msg=="2"||msg=="3"){
                   self.appDelegate.POS = msg
                   self.appDelegate.posflag = true
                    
                }
                else if (msg=="UP"){
                    self.appDelegate.UP = msg
                    self.appDelegate.upflag = true
                }
                else if (msg=="DOWN"){
                    self.appDelegate.DOWN = msg
                    self.appDelegate.downflag = true
                }
                //self.Receive(msg)
                
            }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
            
            // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!, withError error: NSError!)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!)  {
            // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
            
    }
    
    
    
    func onUpdate(timer : NSTimer){
        if(appDelegate.gameset && appDelegate.clear){
            appDelegate.gameset = false
            appDelegate.clear = false
            
            sendMes(String(stringInterpolationSegment: appDelegate.cnt))
            sendMes("clear")
            
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "s2" )
            self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
            
        }
        
        else if(appDelegate.gameset){
            
            sendMes("over")
            appDelegate.gameset = false
            // 遷移するViewを定義する.
            
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "s1" )
            self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
        }
        appDelegate.cnt += 0.1
        //println(appDelegate.cnt)
    }
    
    
}
