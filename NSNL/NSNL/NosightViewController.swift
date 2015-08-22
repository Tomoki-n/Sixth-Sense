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
    
    var buffer :ALuint = 0
    var source :ALuint = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var device:COpaquePointer
        var context:COpaquePointer
        
        device = alcOpenDevice(UnsafePointer(bitPattern: 0))
        
        context = alcCreateContext(device, nil)
        alcMakeContextCurrent(context)
        
        var error:ALenum
        alGetError()
        alGenBuffers(1,&buffer)
        
        alGetError()
        alGenSources(1, &source)
        
        alSourcei(source, AL_LOOPING, AL_TRUE)
        //alSourcei(source, AL_PITCH, 1.0)
        //alSourcei(source, AL_GAIN, 0.45)
        alSource3f(source, AL_POSITION, 10, 20, 30);
        
        var data :NSData
        var format:ALenum
        var size:ALsizei
        var freq:ALsizei
        
        var bundle:NSBundle =  NSBundle.mainBundle()
        
        //var fileURL :CFURLRef = (__bridge CFURLRef) NSURL.fileURLWithPath:bundle pathForResource:fileNameofType:@"caf";
        alSourcei(source, AL_BUFFER, buffer)
        
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
  


    @IBAction func SendGo(sender: UIButton) { sendMes("UP") }
    
    
    override func viewDidAppear(animated: Bool) {
        if (getid == 0){
            getid = 1
            self.presentViewController(self.browser, animated: true, completion: nil)
        }
        
        if (getid == 1){
            
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
        
        
        //声をだす
        
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
    
        if heading >= 0 && heading <= 89 {
            if prevpos >= 0 && prevpos<=89 { }
            else {
                prevpos = Int(heading)
                self.sendMes("0")
            }
        }
        
        else if heading >= 90 && heading <= 179 {
            if prevpos >= 90 && prevpos<=179 { }
            else {
                prevpos = Int(heading)
                self.sendMes("1")
            }
        }
    
        else if heading >= 180 && heading <= 269 {
            if prevpos >= 180 && prevpos<=269 { }
            else {
                prevpos = Int(heading)
                self.sendMes("2")
            }
        }
    
        else if heading >= 270 && heading <= 359 {
            if prevpos >= 270 && prevpos <= 359{ }
            else {
                prevpos = Int(heading)
                self.sendMes("3")
            }
        }
    }
    
    
}