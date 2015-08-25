//
//  NosightViewController.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/21/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//

import Foundation
import UIKit
import MultipeerConnectivity
import CoreLocation
import OpenAL.ALC
import OpenAL.AL
import AudioToolbox
import AVFoundation

class NosightViewController: UIViewController, MCBrowserViewControllerDelegate,MCSessionDelegate ,CLLocationManagerDelegate {

    
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID! = nil
    
    var lm: CLLocationManager! = nil
    var prevpos : Int = 999
    var nowpos : Int = 999
    
    var getid :Int = 0
    var player:AVAudioPlayer?  //音声を制御するための変数
    var bgmplayer:AVAudioPlayer?  //bgm音声を制御するための変数
    var ememyplayer:AVAudioPlayer?  //ememy音声を制御するための変数
    var efplayer:AVAudioPlayer?  //エフェクト音声を制御するための変数
    var walkplayer:AVAudioPlayer?  //歩く音声を制御するための変数
    var plece:String = "rouka.mp3"
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    func play(soundName:String,state:Int){
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        player = AVAudioPlayer(contentsOfURL: url, error: nil)
        // Optional Chainingを使う。
        if let thePlayer = player {
           
            if(state==1){thePlayer.numberOfLoops = -1}
            thePlayer.prepareToPlay()
            thePlayer.play()
        }
    }
    
    func bgmplay(soundName:String,state:Int){
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        bgmplayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        // Optional Chainingを使う。
        if let thePlayer = bgmplayer {
            
            if(state==1){thePlayer.numberOfLoops = -1}
            thePlayer.prepareToPlay()
            thePlayer.play()
        }
    }
    
    func ememyplay(soundName:String,state:Int){
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        ememyplayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        // Optional Chainingを使う。
        if let thePlayer = ememyplayer {
            
            if(state==1){thePlayer.numberOfLoops = -1}
            thePlayer.prepareToPlay()
            thePlayer.play()
        }
    }
    func efplay(soundName:String,state:Int){
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        efplayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        // Optional Chainingを使う。
        if let thePlayer = efplayer {
            
            if(state==1){thePlayer.numberOfLoops = -1}
            thePlayer.prepareToPlay()
            thePlayer.play()
        }
    }
    func walkerplay(soundName:String,state:Int){
        let soundPath = NSBundle.mainBundle().bundlePath.stringByAppendingPathComponent(soundName)
        let url:NSURL? = NSURL.fileURLWithPath(soundPath)
        walkplayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        // Optional Chainingを使う。
        if let thePlayer = walkplayer {
            
            if(state==2){thePlayer.stop()}
            if(state==1){thePlayer.numberOfLoops = -1}
            thePlayer.prepareToPlay()
            thePlayer.play()
        }
        
        
    }
    
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

  
        
        lm = CLLocationManager()
        // 位置情報を取るよう設定
        // ※ 初回は確認ダイアログ表示
        lm.requestAlwaysAuthorization()
        lm.delegate = self
        lm.startUpdatingHeading() // コンパス更新機能起動

        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCBrowserViewController(serviceType:serviceType,
            session:self.session)
        
        self.browser.delegate = self;
        
        self.assistant = MCAdvertiserAssistant(serviceType:serviceType,
            discoveryInfo:nil, session:self.session)
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
 
    }
  


    @IBAction func SendGo(sender: UIButton) {
        sendMes("UP")
        walkerplay(plece, state: 1)
        
        
    }
    
    
    @IBAction func SendUP(sender: UIButton) {
        sendMes("DOWN")
        walkerplay("muon.mp3", state: 2)
    }
    override func viewDidAppear(animated: Bool) {
        if (getid == 0){
            getid = 1
            self.presentViewController(self.browser, animated: true, completion: nil)
        }
        
        if (getid == 1){
            getid = 2
            bgmplay("thunder.wav", state: 1)
            self.sendMes("FIRSTPOS"+" "+String(stringInterpolationSegment: nowpos))
        }
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
        if Getmsg=="1"{play("1.wav",state: 0)}
        else if Getmsg == "2"{play("2.wav",state: 0)}
        else if Getmsg == "3"{play("3.wav",state: 0)}
        else if Getmsg == "4"{play("4.wav",state: 0)}
        else if Getmsg == "5"{play("5.wav",state: 0)}
        else if Getmsg == "6"{play("6.wav",state: 0)}
        else if Getmsg == "7"{play("7.wav",state: 0)}
        else if Getmsg == "8"{play("8.wav",state: 0)}
        else if Getmsg == "9"{play("9.wav",state: 0)}
        else if Getmsg == "10"{play("10.wav",state: 0)}
        else if Getmsg == "11"{play("11.wav",state: 0)}
        else if Getmsg == "12"{play("12.wav",state: 0)}
        else if Getmsg == "13"{play("13.wav",state: 0)}
        else if Getmsg == "14"{play("14.wav",state: 0)}
      
        else if Getmsg == "15"{ememyplay("e1.wav",state: 0)}
        else if Getmsg == "16"{ememyplay("e2.wav",state: 0)}
        else if Getmsg == "17"{ememyplay("e3.wav",state: 0)}
        else if Getmsg == "18"{ememyplay("e4.mp3",state: 0)}
        else if Getmsg == "19"{ememyplay("e5.mp3",state: 0)}
        else if Getmsg == "20"{ememyplay("e6.mp3",state: 0)}
        else if Getmsg == "21"{ememyplay("e7.mp3",state: 0)}

        else if Getmsg == "22"{efplay("ef1.wav",state: 0)}
        else if Getmsg == "23"{efplay("ef2.m4a",state: 0)}
        else if Getmsg == "24"{efplay("ef3.m4a",state: 0)}
        else if Getmsg == "25"{efplay("ef4.m4a",state: 0)}
        else if Getmsg == "26"{efplay("ef5.mp3",state: 0)}
        else if Getmsg == "27"{efplay("ef6.mp3",state: 0)}
        else if Getmsg == "28"{efplay("ef7.mp3",state: 0)}
        else if Getmsg == "29"{efplay("ef8.mp3",state: 0)}
        else if Getmsg == "30"{efplay("ef9.wav",state: 0)}
            
        else if Getmsg == "31"{efplay("daruma.wav",state: 0)}
        else if Getmsg == "32"{efplay("daremo.wav",state: 0)}
        else if Getmsg == "33"{efplay("hdaruma.wav",state: 0)}
        else if Getmsg == "34"{efplay("hdaremo.wav",state: 0)}
        else if Getmsg == "35"{efplay("mdaruma.wav",state: 0)}
        else if Getmsg == "36"{efplay("mdaruma.wav",state: 0)}
        else if Getmsg == "37"{efplay("gata.mp3",state: 0)}
        else if Getmsg == "999"{play("stop.wav", state: 0)}
            
        else if Getmsg == "hit"{
            walkerplay("muon.mp3", state: 1)
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        else if Getmsg == "rouka"{self.plece = "rouka"}
        else if Getmsg == "water"{self.plece = "water"}
        else if Getmsg == "over"{
         
            appDelegate.gameset = false
            // 遷移するViewを定義する.
          
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "s1" )
            
            self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
            
        }
    
        else if Getmsg == "clear"{
            appDelegate.gameset = false
            appDelegate.clear = false
            
            var targetView: AnyObject = self.storyboard!.instantiateViewControllerWithIdentifier( "s2" )
            
            self.presentViewController( targetView as! UIViewController, animated: true, completion: nil)
        }
        
        else {
          //  appDelegate.cnt = Float(Getmsg) as! Float
            
        }
        
        
        
    }

    

    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding) as! String
                
                self.Receive(msg)
                
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
    
    
    func locationManager(manager:CLLocationManager, didUpdateHeading newHeading:CLHeading) {
          var heading:CLLocationDirection = newHeading.magneticHeading
       
        
        
        if prevpos == 999{
            nowpos = Int(heading)
            
            if heading >= 0 && heading <= 89 {nowpos = 0}
            else if heading >= 90 && heading <= 179 {nowpos = 1}
            else if heading >= 180 && heading <= 269{nowpos = 2}
            else if heading >= 270 && heading <= 359 {nowpos = 3}
            self.sendMes("FIRSTPOS"+" "+String(stringInterpolationSegment: nowpos))
            prevpos = nowpos
        }
    
        if heading >= 5 && heading <= 84 {
            if prevpos >= 0 && prevpos<=89 { }
            else {
                prevpos = Int(heading)
                self.sendMes("0")
            }
        }

        else if heading >= 95 && heading <= 174 {
            if prevpos >= 90 && prevpos<=179 { }
            else {
                prevpos = Int(heading)
                self.sendMes("1")
            }
        }
    
        else if heading >= 185 && heading <= 264 {
            if prevpos >= 180 && prevpos<=269 { }
            else {
                prevpos = Int(heading)
                self.sendMes("2")
            }
        }
    
        else if heading >= 275 && heading <= 354 {
            if prevpos >= 270 && prevpos <= 359{ }
            else {
                prevpos = Int(heading)
                self.sendMes("3")
            }
        }
    }
    
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if event.type == UIEventType.Motion && event.subtype == UIEventSubtype.MotionShake {
            // シェイク動作終了時の処理
            println("シェイク")
        }
    }
}