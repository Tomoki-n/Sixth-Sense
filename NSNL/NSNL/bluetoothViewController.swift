//
//  ViewController.swift
//  NSNL
//
//  Created by Nishinaka Tomoki on 8/20/15.
//  Copyright (c) 2015 Nishinaka Tomoki. All rights reserved.
//
import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate,MCSessionDelegate {
    
    let serviceType = "LCOC-Chat"
    
    var browser : MCBrowserViewController!
    var assistant : MCAdvertiserAssistant!
    var session : MCSession!
    var peerID: MCPeerID!
    
    @IBOutlet var ChatView: UITextView!
    @IBOutlet var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 位置とサイズを指定してボタンを初期化
        var button : UIButton = UIButton(frame:CGRectMake(316, 203,36, 30))
        // 通常時のタイトルと色を指定
        button.setTitle("Send", forState: .Normal)
        
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        // ボタンを角丸に
        button.layer.cornerRadius = 10
        // ボーダーの線の太さを指定
        button.layer.borderWidth = 1
        // 画面に配置
        self.view.addSubview(button)
        
        button.addTarget(self, action: "sendChat:", forControlEvents:.TouchUpInside)
        
        
        // 位置とサイズを指定してボタンを初期化
        var button1 : UIButton = UIButton(frame:CGRectMake(272, 203,36, 30))
        // 通常時のタイトルと色を指定
        button1.setTitle("CNT", forState: .Normal)
        
        button1.setTitleColor(UIColor.grayColor(), forState: .Normal)
        // ボタンを角丸に
        button1.layer.cornerRadius = 10
        // ボーダーの線の太さを指定
        button1.layer.borderWidth = 1
        // 画面に配置
        self.view.addSubview(button1)
        
        button1.addTarget(self, action: "showBrowser:", forControlEvents:.TouchUpInside)
        
      
        
        // 表示するコンテンツの矩形を指定
        var rect : CGRect = CGRectMake(16, 241 ,350, 400)
        // UIViewオブジェクトを生成
        self.ChatView = UITextView(frame:rect)
        // 背景色を指定
        self.ChatView.backgroundColor = UIColor.whiteColor()
        // タグを指定
        self.ChatView.tag = 1
        // 画面に配置
        self.view.addSubview(ChatView)
        
        
        
       
        
        var rect2 : CGRect = CGRectMake(31, 203, 232, 30)
        
        messageField = UITextField(frame: rect2)
        
        self.view.addSubview(messageField)
        
        
        
        
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
    
    @IBAction func sendChat(sender: UIButton) {
        // Bundle up the text in the message field, and send it off to all
        // connected peers
        
        let msg = self.messageField.text.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        var error : NSError?
        
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
        self.updateChat(self.messageField.text, fromPeer: self.peerID)
        
        self.messageField.text = ""
    }
    
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        // Appends some text to the chat view
        
        // If this peer ID is the local device's peer ID, then show the name
        // as "Me"
        var name : String
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
        // Add the name to the message and display it
        let message = "\(name): \(text)\n"
        self.ChatView.text = self.ChatView.text + message
        
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        self.presentViewController(self.browser, animated: true, completion: nil)
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
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
              
                self.updateChat(msg! as String, fromPeer: peerID)
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
    
}