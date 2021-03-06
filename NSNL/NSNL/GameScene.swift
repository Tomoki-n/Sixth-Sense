//
//  GameScene.swift
//  NSNL
//
//  Created by itsuki on 2015/08/20.
//  Copyright (c) 2015年 itsuki. All rights reserved.
//

import Foundation
import SpriteKit
import MultipeerConnectivity
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let SHOW_NUM:Bool = false
    let Holl_SCALE:CGFloat = 1.8
//    var controller:GameViewController!
    let GoalCategory: UInt32 = 0x1 << 2
    let GhostCategory: UInt32 = 0x1 << 1
    let WalkerCategory: UInt32 = 0x1 << 3
    let WallCategory:UInt32 = 0x1 << 0
    let CHARA_SCALE:CGFloat = 1.2
    let R_SIZE:CGFloat = 31.0
    let C_SIZE:CGFloat = 24.0
    let MAP_COLS:CGFloat = 8.0
    let GHOST_SIZE:CGFloat = 32.0
    let TILE_SIZE:CGFloat = 32.0
    let SCALE:CGFloat = 0.75
    var map_row:Int = 52 //たて
    var map_columm:Int = 73 //よこ
    var map:[[String]] = []
    var map2:[[String]] = []
    var map3:[[String]] = []
    var map4:[[String]] = []
    var map5:[[String]] = []
    var physic_map:[[String]] = []
    var tilesheet:SKTexture = SKTexture(imageNamed: "mapchip2")
    var tilesheet2:SKTexture = SKTexture(imageNamed: "mapchip3")
    var wld:SKSpriteNode!
    var world:SKSpriteNode!
    var world2:SKSpriteNode!
    var world3:SKSpriteNode!
    var world4:SKSpriteNode!
    var world5:SKSpriteNode!
    var actionFlag:Bool = false
    var fmuki:Int = 0
    var muki:Int = 0 // 0:上,1:右,2:下,3:左
    var soutai:Int = 0
    var walker:SKSpriteNode!
    var shita:SKAction!
    var hidari:SKAction!
    var ue:SKAction!
    var migi:SKAction!
    var Dw:SKAction!
    var Lw:SKAction!
    var Uw:SKAction!
    var Rw:SKAction!
    var Dw2:SKAction!
    var Lw2:SKAction!
    var Uw2:SKAction!
    var Rw2:SKAction!
    var cMove:SKAction!
    var cMove2:SKAction!
    var wMove:SKAction!
    var cFlag:Bool = false
    var wFlag:Bool = false
    var scrView:UIScrollView!
    var button1,button2,button3,button4,button5,button6,button7,button8,button9,button10,button11,button12,button13,button14,button15:UIButton!
    var centerB:UIButton!
    var del: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var atarimuki:Int = -1
    var myImage:SKSpriteNode!
    var mapimage:SKSpriteNode!
    var ghost:SKSpriteNode!
    var gr1:SKAction!
    var gr2:SKAction!
    var gr3:SKAction!
    var gr4:SKAction!
    var move:[CGFloat] = []
    var ghosts:[SKSpriteNode] = []
    var ghost_count:Int = 0
    var disFlag:Bool = false
    var dis2Flag:Bool = false
    var dis3Flag:Bool = false
    var player:AVAudioPlayer?  //音声を制御するための変数
    var sound:NosightViewController!
    
    
    var myAlialLabel: UILabel = UILabel()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let myDrag = UIPanGestureRecognizer(target: self, action: "panGesture:")
        
        self.view?.addGestureRecognizer(myDrag)
        self.backgroundColor = UIColor.blackColor()
        if SHOW_NUM == false{
        myImage = SKSpriteNode(imageNamed: "light.png")
        myImage.size = CGSizeMake(myImage.size.width * Holl_SCALE, myImage.size.height * Holl_SCALE)
            myImage.position = CGPointMake(self.size.width * 2 / 5, self.size.height / 2)
        myImage.zPosition = 2.0
            self.addChild(myImage)
        self.physicsWorld.contactDelegate = self
        
        }
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        if let csvPath = NSBundle.mainBundle().pathForResource("layer1", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map.append(line.componentsSeparatedByString(","))
            }
        }
        if let csvPath = NSBundle.mainBundle().pathForResource("tlayer1", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map2.append(line.componentsSeparatedByString(","))
            }
        }
        if let csvPath = NSBundle.mainBundle().pathForResource("layer2", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map3.append(line.componentsSeparatedByString(","))
            }
        }
        if let csvPath = NSBundle.mainBundle().pathForResource("layer3", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map4.append(line.componentsSeparatedByString(","))
            }
        }
        if let csvPath = NSBundle.mainBundle().pathForResource("tlayer2", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map5.append(line.componentsSeparatedByString(","))
            }
        }
        
        if let csvPath = NSBundle.mainBundle().pathForResource("physicdata3", ofType: "csv") {
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.physic_map.append(line.componentsSeparatedByString(","))
            }
        }
        
        let imageview = UIImageView(image: UIImage(named: "Status.png"))

        imageview.frame = CGRectMake(0, 0, self.size.width * 1 / 5, self.size.height*2)
        scrView = UIScrollView()
        scrView.pagingEnabled = false
        scrView.frame = CGRectMake(self.size.width * 4 / 5, 0, self.size.width * 1 / 5, self.size.height)
        scrView.contentSize = CGSizeMake(self.size.width * 1 / 5, self.size.height * 2)
        scrView.backgroundColor = UIColor.blackColor()
        
        if SHOW_NUM == false{
        self.view?.addSubview(scrView)
        scrView.addSubview(imageview)
        }
        
        button1 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button1.setImage(UIImage(named: "15.png"), forState: .Normal)
        button1.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 40)
        button1.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button1.tag = 1
        button2 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button2.setImage(UIImage(named: "112.png"), forState: .Normal)
        button2.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 90)
        button2.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button2.tag = 2
        button3 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button3.setImage(UIImage(named: "11.png"), forState: .Normal)
        button3.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 140)
        button3.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button3.tag = 3
        button4 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button4.setImage(UIImage(named: "14.png"), forState: .Normal)
        button4.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 190)
        button4.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button4.tag = 4
        button5 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button5.setImage(UIImage(named: "113.png"), forState: .Normal)
        button5.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 240)
        button5.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button5.tag = 5
        button6 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button6.setImage(UIImage(named: "13.png"), forState: .Normal)
        button6.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 290)
        button6.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button6.tag = 6
        button7 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button7.setImage(UIImage(named: "18.png"), forState: .Normal)
        button7.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 340)
        button7.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button7.tag = 7
        button8 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button8.setImage(UIImage(named: "10.png"), forState: .Normal)
        button8.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 390)
        button8.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button8.tag = 8
        button9 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button9.setImage(UIImage(named: "110.png"), forState: .Normal)
        button9.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 440)
        button9.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button9.tag = 9
        button10 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button10.setImage(UIImage(named: "111.png"), forState: .Normal)
        button10.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 490)
        button10.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button10.tag = 10
        button11 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button11.setImage(UIImage(named: "12.png"), forState: .Normal)
        button11.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 540)
        button11.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button11.tag = 11
        button12 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button12.setImage(UIImage(named: "16.png"), forState: .Normal)
        button12.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 590)
        button12.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button12.tag = 12
        button13 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button13.setImage(UIImage(named: "17.png"), forState: .Normal)
        button13.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 640)
        button13.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button13.tag = 13
        button14 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button14.setImage(UIImage(named: "114.png"), forState: .Normal)
        button14.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 690)
        button14.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button14.tag = 14
        
        centerB = UIButton(frame: CGRectMake(0, 0, 40, 40))
        centerB.setImage(UIImage(named: "return.png"), forState: .Normal)
        centerB.layer.position = CGPoint(x: 40, y: self.size.height - 40)
        centerB.addTarget(self, action: "oncenterB:", forControlEvents: .TouchUpInside)
        
        button15 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button15.setImage(UIImage(named: "stop.png"), forState: .Normal)
        button15.layer.position = CGPoint(x: 60, y: self.size.height - 120)
        button15.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button15.tag = 999
        
        //let myAlialLabel: UILabel = UILabel()
        myAlialLabel.font = UIFont(name:"ArialHebew", size:UIFont.labelFontSize())
        myAlialLabel.text = "0"
        myAlialLabel.frame = CGRect(x:0, y: 0, width: 300, height: 150)
        myAlialLabel.layer.position = CGPoint(x:160 , y:20)
        myAlialLabel.textColor = UIColor.whiteColor()
        myAlialLabel.textAlignment = NSTextAlignment.Left
        self.view?.addSubview(myAlialLabel)
        
        if SHOW_NUM == false{
        self.view?.addSubview(centerB)
        
        scrView.addSubview(button1)
        scrView.addSubview(button2)
        scrView.addSubview(button3)
        scrView.addSubview(button4)
        scrView.addSubview(button5)
        scrView.addSubview(button6)
        scrView.addSubview(button7)
        scrView.addSubview(button8)
        scrView.addSubview(button9)
        scrView.addSubview(button10)
        scrView.addSubview(button11)
        scrView.addSubview(button12)
        scrView.addSubview(button13)
        scrView.addSubview(button14)
        self.view?.addSubview(button15)
            
     }
        
        world = SKSpriteNode()
        world.size = CGSizeMake(CGFloat(map_columm) * TILE_SIZE, CGFloat(map_row) * TILE_SIZE)
        world.zPosition = 0
        world.anchorPoint = CGPointMake(0, 0)
        world.position = CGPointMake(0, 0)
 
        
        if SHOW_NUM == false{
            self.addChild(world!)
            print(world.position)
//            self.addChild(world2!)
//            self.addChild(world3!)
//            self.addChild(world4!)
//            self.addChild(world5!)
        }
        //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        //        myLabel.text = "Hello, World!";
        //        myLabel.fontSize = 65;
        //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        //        self.addChild(myLabel)
        if SHOW_NUM == false{
            Map_Create()
            Makewalker()
            MakeGhost(2, ghostpos: zahyou(68, tiley: 7), gCategory: GoalCategory)
            MakeGhost(1, ghostpos:zahyou(19, tiley: 48), gCategory: GhostCategory)
            MakeGhost(1, ghostpos:zahyou(20, tiley: 48), gCategory: GhostCategory)
            MakeGhost(1, ghostpos:zahyou(21, tiley: 48), gCategory: GhostCategory)
            ghostMove(2, Gmove: ["w","u","w","u","w","u","w","u","w","u","w","u","w","d","w","d","w","d","w","d","w","d","w","d"], moveCnt:[5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3], mode: "R")
            ghostMove(3, Gmove: ["w","u","w","u","w","u","w","u","w","u","w","u","w","d","w","d","w","d","w","d","w","d","w","d"], moveCnt:[5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3], mode: "R")
            ghostMove(4, Gmove: ["w","u","w","u","w","u","w","u","w","u","w","u","w","d","w","d","w","d","w","d","w","d","w","d"], moveCnt:[5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3,5,3], mode: "R")
            
            MakeGhost(3, ghostpos: zahyou(52, tiley: 17), gCategory: GhostCategory)
            ghostMove(5, Gmove: ["w","d","w","d","w","d","w","d","w","d","w","d","w","l"], moveCnt: [1,1,1,1,1,1,1,1,1,1,1,1,2,1], mode: "N")
            MakeGhost(1, ghostpos:zahyou(20, tiley: 50), gCategory: GhostCategory)
        }else{
            Map_Number()
        }
    }
    
    func zahyou(var tilex:CGFloat, var tiley:CGFloat) -> CGPoint{
        var wx:CGFloat = (tilex) * TILE_SIZE + TILE_SIZE / 2
        var wy:CGFloat = (CGFloat(map_row) - tiley) * TILE_SIZE + TILE_SIZE / 2
        var wpoint:CGPoint = CGPointMake(wx, wy)
        return wpoint
    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        actionFlag = true
//    }
    
//    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
//        for touch: AnyObject in touches {
//            let location = touch.locationInNode(self)
//            
//            myImage.position = location
//            
//        }
//        
//    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        //first=walker,second=wall
        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // walkerとwallが接したときの処理。
        if firstBody.categoryBitMask & WalkerCategory != 0 &&
            secondBody.categoryBitMask & WallCategory != 0 {
                atarimuki = soutai
                println("HIT")
                del.controller.sendMes("hit")
        }else if firstBody.categoryBitMask & WalkerCategory != 0 &&
            secondBody.categoryBitMask & GhostCategory != 0{
                println("DEAD")
               
                if (!del.gd) {
                    del.gameset = true
                    del.gd = true
                }
                
        
        }else if
            firstBody.categoryBitMask & WalkerCategory != 0 &&
            secondBody.categoryBitMask & GoalCategory != 0{
                
                println("END")
                
              
                //let ud = NSUserDefaults.standardUserDefaults()
        /*
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
                    if scores[1] > del.cnt{
                        scores[1] = del.cnt
                    }
                    else if scores[2] > del.cnt{
                        scores[2] = del.cnt
                    }
                    else if scores[3] > del.cnt{
                        scores[3] = del.cnt
                    }
                    
                    ud.setObject(scores, forKey: "score")
                    ud.synchronize()
                    
                }
                else{
                    var scores:[Float] = []
                    scores.append(del.cnt)
                    scores.append(40000.0)
                    scores.append(50000.0)
                    ud.setObject(scores, forKey: "score")
                    ud.synchronize()
                    
                }
*/
                
                if (!del.gd) {
                    del.gameset = true
                    del.clear = true
                    del.gd = true
                }
        }
        
        
        
        
    }
    func distance(var gst:SKSpriteNode) -> CGFloat{
        var disx:CGFloat = gst.position.x - self.walker.position.x
        var disy:CGFloat = gst.position.y - self.walker.position.y


        return sqrt(disx*disx + disy*disy)
    }
    

    func Map_Number(){
        var maptex:SKTexture = SKTexture(imageNamed: "mapchip2.png")
        mapimage = SKSpriteNode(texture: maptex)
        mapimage.xScale = SCALE
        mapimage.yScale = SCALE
        mapimage.anchorPoint = CGPointMake(0, 0)
        self.addChild(mapimage)
        var mr:Int = Int(tilesheet.size().height / TILE_SIZE)
        var mc:Int = Int(tilesheet.size().width / TILE_SIZE)
        for i in 0..<mc{
            for j in 0..<mr{

                
                var position:CGPoint = CGPointMake(CGFloat(i) * self.TILE_SIZE, CGFloat(j) * self.TILE_SIZE)
                var pointLabel:SKLabelNode = SKLabelNode(fontNamed: "Bold")
                pointLabel.text = String(i + j * mc)
                pointLabel.position = CGPointMake(position.x + TILE_SIZE / 2, position.y + TILE_SIZE / 2)
                pointLabel.fontColor = UIColor.whiteColor()
                pointLabel.fontSize = 14.0
                pointLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
                mapimage.addChild(pointLabel)
                
            }
        }
    }

    
    func Map_Create(){
        var mr:Int = Int(tilesheet.size().height / TILE_SIZE)
        var mr2:Int = Int(tilesheet2.size().height / TILE_SIZE)
        var mc:Int = Int(tilesheet.size().width / TILE_SIZE)
        for i in 0..<map_row{
            for j in 0..<map_columm{
                let m1:Int = self.map[i][j].toInt()!
                let m2:Int = self.map2[i][j].toInt()!
                let m3:Int = self.map3[i][j].toInt()!
                let m4:Int = self.map4[i][j].toInt()!
                let m5:Int = self.map5[i][j].toInt()!
                let q:Int = self.physic_map[i][j].toInt()!
                var p:Int = 0
                var temp:Int = 0
                var tempsheet:SKTexture!
                
                for k in 1...5{
                
                    switch(k){
                    case 1:
                        p = m1
                        tempsheet = tilesheet
                        temp = mr
                        break
                    case 2:
                        p = m2
                        tempsheet = tilesheet2
                        temp = mr2
                        break
                    case 3:
                        p = m3
                        tempsheet = tilesheet
                        temp = mr
                        break
                    case 4:
                        p = m4
                        tempsheet = tilesheet
                        temp = mr
                        break
                    case 5:
                        p = m5
                        tempsheet = tilesheet2
                        temp = mr2
                        break
                    default:
                        break
                    }
                    
                    if p != -1{
                var x:CGFloat = CGFloat(CGFloat(p % Int(self.MAP_COLS)) * TILE_SIZE / tempsheet.size().width)
                var y:CGFloat = CGFloat(CGFloat((temp-1) - (p / Int(self.MAP_COLS))) * TILE_SIZE / tempsheet.size().height)
                var w:CGFloat = CGFloat(TILE_SIZE / tempsheet.size().width)
                var h:CGFloat = CGFloat(TILE_SIZE / tempsheet.size().height)
                
                
                var Rect:CGRect = CGRectMake(x, y, w, h)
                        var tile:SKTexture = SKTexture(rect: Rect, inTexture: tempsheet)
                var tileSprite:SKSpriteNode = SKSpriteNode(texture: tile)
                
                var position:CGPoint = CGPointMake(CGFloat(j) * self.TILE_SIZE,self.world.size.height -  CGFloat(i) * self.TILE_SIZE)
                tileSprite.anchorPoint = CGPointMake(0, 0)
                tileSprite.position = position
                
                if q == 0 && p == m1{
                    tileSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(TILE_SIZE, TILE_SIZE), center: CGPointMake(TILE_SIZE / 2, TILE_SIZE / 2))
                    tileSprite.physicsBody!.dynamic = false
                    tileSprite.physicsBody?.categoryBitMask = WallCategory
                    tileSprite.physicsBody?.collisionBitMask = WalkerCategory
                    tileSprite.physicsBody?.contactTestBitMask = WalkerCategory
                }
                
                self.world.addChild(tileSprite)
                 
                    }
                }
                
            }
        }
    }
    
    func goFront(){
        let Up:SKAction = SKAction.moveByX(100, y: 100, duration: 1)
        world.runAction(Up)
    }
    
    func Makewalker(){
        var clotharmor:SKTexture = SKTexture(imageNamed: "chara02.gif")
        var textures0:NSMutableArray = NSMutableArray()
        var textures1:NSMutableArray = NSMutableArray()
        var textures2:NSMutableArray = NSMutableArray()
        var textures3:NSMutableArray = NSMutableArray()
        
        var texture0:SKTexture!
        var texture1:SKTexture!
        var texture2:SKTexture!
        var texture3:SKTexture!
        
        for row1 in 0..<4{
            for col1 in 3..<7{
                var x:CGFloat = 0
                var y:CGFloat = 0
                var w:CGFloat = 0
                var h:CGFloat = 0
                
                if(col1 != 6){
                    x = CGFloat(CGFloat(col1) * self.C_SIZE / clotharmor.size().width)
                    y = CGFloat(CGFloat(row1) * self.R_SIZE / clotharmor.size().height)
                    w = CGFloat(C_SIZE / clotharmor.size().width)
                    h = CGFloat(R_SIZE / clotharmor.size().height)
                }else{
                    x = CGFloat(4 * self.C_SIZE / clotharmor.size().width)
                    y = CGFloat(CGFloat(row1) * self.R_SIZE / clotharmor.size().height)
                    w = CGFloat(C_SIZE / clotharmor.size().width)
                    h = CGFloat(R_SIZE / clotharmor.size().height)
                }
                
                
                
                switch (row1) {
                case 0:
                    texture0 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures0.addObject(texture0)
                    break
                case 1:
                    texture1 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures1.addObject(texture1)
                    break
                case 2:
                    texture2 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures2.addObject(texture2)
                    break
                case 3:
                    texture3 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures3.addObject(texture3)
                    break
                default:
                    break
                }
            }
        }
        
        self.walker = SKSpriteNode(texture: texture3)
        self.walker.position = CGPoint(x: self.world.size.width / 2, y: self.size.height/2)
        self.walker.size = CGSizeMake(self.walker.size.width * self.CHARA_SCALE, self.walker.size.height * self.CHARA_SCALE)
        self.walker.zPosition = 1.0
        
        
        walker.physicsBody = SKPhysicsBody(texture: texture1, size: walker.frame.size)
        walker.physicsBody!.affectedByGravity = false
        walker.physicsBody!.restitution = 1.0
        walker.physicsBody!.linearDamping = 0
        walker.physicsBody!.friction = 0
        walker.physicsBody!.allowsRotation = false
        walker.physicsBody!.usesPreciseCollisionDetection = true
        walker.physicsBody?.categoryBitMask = WalkerCategory
        walker.physicsBody?.contactTestBitMask = WallCategory | GhostCategory | GoalCategory
        
//        self.walker.physicsBody = SKPhysicsBody(texture: texture1, size: walker.frame.size)
//        self.walker.physicsBody!.allowsRotation = false
//        self.walker.physicsBody?.categoryBitMask = WalkerCategory
//        self.walker.physicsBody?.contactTestBitMask = WallCategory
        self.world.addChild(walker)
        self.world.position = CGPointMake(-(self.walker.position.x - self.size.width * 2 / 5), -(self.walker.position.y - self.size.height/2))
        
        
        var Dwalk:SKAction = SKAction.animateWithTextures(textures1 as [AnyObject], timePerFrame: 0.2)
        var Lwalk:SKAction = SKAction.animateWithTextures(textures0 as [AnyObject], timePerFrame: 0.2)
        var Uwalk:SKAction = SKAction.animateWithTextures(textures3 as [AnyObject], timePerFrame: 0.2)
        var Rwalk:SKAction = SKAction.animateWithTextures(textures2 as [AnyObject], timePerFrame: 0.2)
        
        var Down:SKAction = SKAction.moveByX(0, y: -80, duration: 0.8)
        var Left:SKAction = SKAction.moveByX(-80, y: 0, duration: 0.8)
        var Up:SKAction = SKAction.moveByX(0, y: 80, duration: 0.8)
        var Right:SKAction = SKAction.moveByX(80, y: 0, duration: 0.8)
        
        shita = SKAction.repeatActionForever(Down)
        hidari = SKAction.repeatActionForever(Left)
        ue = SKAction.repeatActionForever(Up)
        migi = SKAction.repeatActionForever(Right)
        
        Dw = SKAction.repeatAction(Dwalk, count: 1)
        Lw = SKAction.repeatAction(Lwalk, count: 1)
        Uw = SKAction.repeatAction(Uwalk, count: 1)
        Rw = SKAction.repeatAction(Rwalk, count: 1)
        
        Dw2 = SKAction.repeatActionForever(Dwalk)
        Lw2 = SKAction.repeatActionForever(Lwalk)
        Uw2 = SKAction.repeatActionForever(Uwalk)
        Rw2 = SKAction.repeatActionForever(Rwalk)
    }
    
    func MakeGhost(var ghostnum:Int , var ghostpos:CGPoint, var gCategory:UInt32){
        ghost_count++
        var ghostsozai:String = "ghost" + String(ghostnum) + ".png"
        var clotharmor:SKTexture = SKTexture(imageNamed: ghostsozai)
        var textures0:NSMutableArray = NSMutableArray()
        var textures1:NSMutableArray = NSMutableArray()
        var textures2:NSMutableArray = NSMutableArray()
        var textures3:NSMutableArray = NSMutableArray()
        
        var texture0:SKTexture!
        var texture1:SKTexture!
        var texture2:SKTexture!
        var texture3:SKTexture!
        
        for row1 in 0..<4{
            for col1 in 0..<4{
                var x:CGFloat = 0
                var y:CGFloat = 0
                var w:CGFloat = 0
                var h:CGFloat = 0
                
                if(col1 != 3){
                    x = CGFloat(CGFloat(col1) * self.GHOST_SIZE / clotharmor.size().width)
                    y = CGFloat(CGFloat(row1) * self.GHOST_SIZE / clotharmor.size().height)
                    w = CGFloat(GHOST_SIZE / clotharmor.size().width)
                    h = CGFloat(GHOST_SIZE / clotharmor.size().height)
                }else{
                    x = CGFloat(1 * self.GHOST_SIZE / clotharmor.size().width)
                    y = CGFloat(CGFloat(row1) * self.GHOST_SIZE / clotharmor.size().height)
                    w = CGFloat(GHOST_SIZE / clotharmor.size().width)
                    h = CGFloat(GHOST_SIZE / clotharmor.size().height)
                }
                
                
                
                switch (row1) {
                case 0:
                    texture0 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures0.addObject(texture0)
                    break
                case 1:
                    texture1 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures1.addObject(texture1)
                    break
                case 2:
                    texture2 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures2.addObject(texture2)
                    break
                case 3:
                    texture3 = SKTexture(rect: CGRectMake(x, y, w, h), inTexture: clotharmor)
                    textures3.addObject(texture3)
                    break
                default:
                    break
                }
            }
        }
        
        self.ghost = SKSpriteNode(texture: texture3)
        self.ghost.position = ghostpos
//        self.ghost.position = CGPoint(x: self.size.width, y: self.size.height / 2)
        self.ghost.size = CGSizeMake(self.ghost.size.width * self.CHARA_SCALE, self.ghost.size.height * self.CHARA_SCALE)
        self.ghost.zPosition = 1.0
        
        
        ghost.physicsBody = SKPhysicsBody(texture: texture1, size: ghost.frame.size)
        ghost.physicsBody!.affectedByGravity = false
        ghost.physicsBody!.restitution = 1.0
        ghost.physicsBody!.linearDamping = 0
        ghost.physicsBody!.friction = 0
        ghost.physicsBody!.allowsRotation = false
        ghost.physicsBody!.usesPreciseCollisionDetection = true
        ghost.physicsBody?.categoryBitMask = gCategory
//        ghost.physicsBody?.contactTestBitMask = WallCategory
        
        ghosts.append(ghost)
        self.world.addChild(ghosts[ghost_count-1])
        
        
        var Dwalk:SKAction = SKAction.animateWithTextures(textures3 as [AnyObject], timePerFrame: 0.2)
        var Lwalk:SKAction = SKAction.animateWithTextures(textures2 as [AnyObject], timePerFrame: 0.2)
        var Uwalk:SKAction = SKAction.animateWithTextures(textures0 as [AnyObject], timePerFrame: 0.2)
        var Rwalk:SKAction = SKAction.animateWithTextures(textures1 as [AnyObject], timePerFrame: 0.2)
        
        var Down:SKAction = SKAction.moveByX(0, y: -80, duration: 0.8)
        var Left:SKAction = SKAction.moveByX(-80, y: 0, duration: 0.8)
        var Up:SKAction = SKAction.moveByX(0, y: 80, duration: 0.8)
        var Right:SKAction = SKAction.moveByX(80, y: 0, duration: 0.8)
        
        gr1 = SKAction.group([Dwalk,Down])
        gr2 = SKAction.group([Lwalk,Left])
        gr3 = SKAction.group([Uwalk,Up])
        gr4 = SKAction.group([Rwalk,Right])
        
    }
    
    func ghostMove(var ghostnum:Int, var Gmove:[String], var moveCnt:[Int], var mode:String){
        var seq:[SKAction] = []
        var tempgr:SKAction!
        for i in 0..<Gmove.count{
            switch(Gmove[i]){
            case "d"://下
                tempgr = SKAction.repeatAction(gr1, count: moveCnt[i])
                break
            case "l"://左
                tempgr = SKAction.repeatAction(gr2, count: moveCnt[i])
                break
            case "u"://上
                tempgr = SKAction.repeatAction(gr3, count: moveCnt[i])
                break
            case "r"://右
                tempgr = SKAction.repeatAction(gr4, count: moveCnt[i])
                break
            case "w":
                var Wtime:NSTimeInterval = NSTimeInterval(moveCnt[i])
                tempgr = SKAction.waitForDuration(Wtime)
                break
            default:
                break
            }
            seq.append(tempgr)
        }
        let moveseq:SKAction = SKAction.sequence(seq)
        var modemove:SKAction!
        if mode == "R"{//無限リピート
            modemove = SKAction.repeatActionForever(moveseq)
        }else if mode == "N"{//１回だけ
            modemove = moveseq
        }else{//回数指定
            var Mcount:Int = mode.toInt()!
            modemove = SKAction.repeatAction(moveseq, count: Mcount)
        }

        ghosts[ghostnum-1].runAction(modemove)
    }
    
    func first(){
        switch(del.FirstPOS){
        case "FIRSTPOS 0":
            fmuki = 0
            break
        case "FIRSTPOS 1":
            fmuki = 1
            break
        case "FIRSTPOS 2":
            fmuki = 2
            break
        case "FIRSTPOS 3":
            fmuki = 3
            break
        default:
            break
        }

        println(fmuki)

    }

    internal func panGesture(sender: UIPanGestureRecognizer){
        var p:CGPoint = sender.translationInView(self.view!)
        
        if SHOW_NUM == false{
        var movePoint:CGPoint = CGPointMake(world.position.x + p.x, world.position.y  - p.y)
        world.position = movePoint
        }else{
            var movePoint:CGPoint = CGPointMake(mapimage.position.x + p.x, mapimage.position.y  - p.y)
            mapimage.position = movePoint
            
        }
        
        sender.setTranslation(CGPointZero, inView: self.view)
        
    }

    internal func onbutton(sender:UIButton){
        Receive(String(sender.tag))
        del.controller.sendMes(String(sender.tag))
        
    }
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
            
        
        else if Getmsg == "999"{play("stop.wav", state: 0)}
            
        
        
    }

    
    internal func oncenterB(sender:UIButton){
        self.world.position = CGPointMake(-(self.walker.position.x - self.size.width * 2 / 5), -(self.walker.position.y - self.size.height/2))
        
    }
    
    func sendmes(mes:String){
        del.controller.sendMes(mes)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        myAlialLabel.text = "TIME:" + " " + String(stringInterpolationSegment: Int(del.cnt))
        
        
        if walker.position.x <= zahyou(21, tiley: 0).x{
            if disFlag == false{
                sendmes("33")
                disFlag = true
            }
        }

        if walker.position.y  >= zahyou(0, tiley: 34).y{
            if dis2Flag == false{
                sendmes("25")
                dis2Flag = true
            }
        }

        if walker.position.x >= zahyou(65, tiley: 0).x && walker.position.y >= zahyou(0, tiley: 27).y && walker.position.y <= zahyou(0, tiley: 20).y{
            if dis3Flag == false{
        //        println("test")
                sendmes("37")
                dis3Flag = true
            }
        }
        
        if atarimuki == soutai{
            del.downflag = false
            walker.removeAllActions()
//            walker.removeActionForKey("cm1")
//            walker.removeActionForKey("cm2")
            println(atarimuki)
            switch(atarimuki){
            case 0:
                walker.runAction(SKAction.moveByX(0, y: -10, duration: 0.2))
                break
            case 1:
                walker.runAction(SKAction.moveByX(-10, y: 0, duration: 0.2))
                break
            case 2:
                walker.runAction(SKAction.moveByX(0, y: 10, duration: 0.2))
                break
            case 3:
                walker.runAction(SKAction.moveByX(10, y: 0, duration: 0.2))
                break
            default:
                break
            }

            atarimuki = -1
        }
        
        if del.firstflag == true{
            first()
            del.firstflag = false
        }
        
        if del.posflag == true{
            del.posflag = false
            muki = del.POS.toInt()!
            soutai = (muki + fmuki) % 4
            
            switch(soutai){
            case 0:
                walker.runAction(Uw)
                break
            case 1:
                walker.runAction(Rw)
                break
            case 2:
                walker.runAction(Dw)
                break
            case 3:
                walker.runAction(Lw)
                break
            default:
                break
            }
        }
        
        
        
        if del.upflag == true{
            del.upflag = false
            switch(soutai){
            case 0:
                cMove = Uw2
                cMove2 = ue
                break
            case 1:
                cMove = Rw2
                cMove2 = migi
                break
            case 2:
                cMove = Dw2
                cMove2 = shita
                break
            case 3:
                cMove = Lw2
                cMove2 = hidari
                break
            default:
                break
            }

            walker.runAction(cMove, withKey: "cm1")
                walker.runAction(cMove2, withKey: "cm2")
            
        }
        
        if del.downflag == true{
            del.downflag = false
            walker.removeActionForKey("cm1")
            walker.removeActionForKey("cm2")
        }
    }
}
