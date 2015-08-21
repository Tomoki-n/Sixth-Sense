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

class CoopViewController: UIViewController, MCBrowserViewControllerDelegate,MCSessionDelegate,UIActionSheetDelegate {
    
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID! = nil
    
    var getid :Int = 0
    
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
        
        // tell the assistant to start advertising our fabulous chat
        self.assistant.start()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        if (getid == 0){
            getid = 1
            self.presentViewController(self.browser, animated: true, completion: nil)
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
                
                println(msg)
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
    func actionSheet(sheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
      self.view.window?.rootViewController!.presentViewController(self.browser, animated: true, completion: nil)
    }
    
}