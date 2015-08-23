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
class GameScene: SKScene, SKPhysicsContactDelegate{
    
    let SHOW_NUM:Bool = true
    let Holl_SCALE:CGFloat = 1.8
//    var controller:GameViewController!
    let WalkerCategory: UInt32 = 0x1 << 1
    let WallCategory:UInt32 = 0x1 << 0
    let CHARA_SCALE:CGFloat = 1.2
    let R_SIZE:CGFloat = 31.0
    let C_SIZE:CGFloat = 24.0
    let MAP_COLS:CGFloat = 8.0
    let TILE_SIZE:CGFloat = 32.0
    let SCALE:CGFloat = 0.75
    var map_row:Int = 52
    var map_columm:Int = 48
    var map:[[String]] = []
    var physic_map:[[String]] = []
    var tilesheet:SKTexture = SKTexture(imageNamed: "mapchip2")
    var world:SKSpriteNode!
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
    var cMove:SKAction!
    var cMove2:SKAction!
    var wMove:SKAction!
    var cFlag:Bool = false
    var wFlag:Bool = false
    var scrView:UIScrollView!
    var button1:UIButton!
    var button2:UIButton!
    var button3:UIButton!
    var centerB:UIButton!
    var del: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
//    var atarimuki:Int = -1
    var myImage:SKSpriteNode!
    var mapimage:SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        let myDrag = UIPanGestureRecognizer(target: self, action: "panGesture:")
        
        self.view?.addGestureRecognizer(myDrag)
        
        if SHOW_NUM == false{
        myImage = SKSpriteNode(imageNamed: "light.png")
        myImage.size = CGSizeMake(myImage.size.width * Holl_SCALE, myImage.size.height * Holl_SCALE)
        
        self.physicsWorld.contactDelegate = self
        
        }
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        if let csvPath = NSBundle.mainBundle().pathForResource("Mapdata2", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map.append(line.componentsSeparatedByString(","))
            }
        }
        
        if let csvPath = NSBundle.mainBundle().pathForResource("physicdata1", ofType: "csv") {
            
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
        button1.setImage(UIImage(named: "susunde.png"), forState: .Normal)
        button1.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 40)
        button1.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button1.tag = 1
        button2 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button2.setImage(UIImage(named: "migihe.png"), forState: .Normal)
        button2.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 90)
        button2.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button2.tag = 2
        button3 = UIButton(frame: CGRectMake(0, 0, 100, 40))
        button3.setImage(UIImage(named: "hidarihe.png"), forState: .Normal)
        button3.layer.position = CGPoint(x: scrView.frame.size.width / 2, y: 140)
        button3.addTarget(self, action: "onbutton:", forControlEvents: .TouchUpInside)
        button3.tag = 3
        
        centerB = UIButton(frame: CGRectMake(0, 0, 40, 40))
        centerB.backgroundColor = UIColor.whiteColor()
        centerB.layer.position = CGPoint(x: 40, y: self.size.height - 40)
        centerB.addTarget(self, action: "oncenterB:", forControlEvents: .TouchUpInside)
        if SHOW_NUM == false{
        self.view?.addSubview(centerB)
        
        scrView.addSubview(button1)
        scrView.addSubview(button2)
        scrView.addSubview(button3)
        
        }
        
        world = SKSpriteNode()
        world.size = CGSizeMake(CGFloat(map_row) * TILE_SIZE, CGFloat(map_columm) * TILE_SIZE)
        world.zPosition = 0
        
        if SHOW_NUM == false{
        self.addChild(world!)
        }
        //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        //        myLabel.text = "Hello, World!";
        //        myLabel.fontSize = 65;
        //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        //        self.addChild(myLabel)
        if SHOW_NUM == false{
        Map_Create()
        Makewalker()
        }else{
            Map_Number()
        }
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
    
//    func didBeginContact(contact: SKPhysicsContact) {
//        
//        var firstBody, secondBody: SKPhysicsBody
//        
//        //first=walker,second=wall
//        if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask {
//            firstBody = contact.bodyA
//            secondBody = contact.bodyB
//        } else {
//            firstBody = contact.bodyB
//            secondBody = contact.bodyA
//        }
//        
//        // walkerとwallが接したときの処理。
//        if firstBody.categoryBitMask & WalkerCategory != 0 &&
//            secondBody.categoryBitMask & WallCategory != 0 {
//                print("p")
//                atarimuki = soutai
//
//        }
//    }
    

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
        for i in 0..<map_row{
            for j in 0..<map_columm{
                let p:Int = self.map[i][j].toInt()!
                let q:Int = self.physic_map[i][j].toInt()!
                
                var x:CGFloat = CGFloat(CGFloat(p % Int(self.MAP_COLS)) * TILE_SIZE / tilesheet.size().width)
                var y:CGFloat = CGFloat(CGFloat(p / Int(self.MAP_COLS)) * TILE_SIZE / tilesheet.size().height)
                var w:CGFloat = CGFloat(TILE_SIZE / tilesheet.size().width)
                var h:CGFloat = CGFloat(TILE_SIZE / tilesheet.size().height)
                
                print(x)
                print(",")
                print(y)
                print(",")
                print(w)
                print(",")
                println(h)
                println(p)
                
                var Rect:CGRect = CGRectMake(x, y, w, h)
                var tile:SKTexture = SKTexture(rect: Rect, inTexture: self.tilesheet)
                var tileSprite:SKSpriteNode = SKSpriteNode(texture: tile)
                
                if q == 0{
                    tileSprite.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(TILE_SIZE, TILE_SIZE))
                    tileSprite.physicsBody!.dynamic = false
                    tileSprite.physicsBody?.categoryBitMask = WallCategory
                    tileSprite.physicsBody?.collisionBitMask = WalkerCategory
                    tileSprite.physicsBody?.contactTestBitMask = WalkerCategory
                }
                
                var position:CGPoint = CGPointMake(CGFloat(j) * self.TILE_SIZE,self.world.size.height -  CGFloat(i) * self.TILE_SIZE)
                tileSprite.anchorPoint = CGPointMake(0, 0)
                tileSprite.position = position
                self.world.addChild(tileSprite)
                
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
        
        self.walker = SKSpriteNode(texture: texture1)
        self.walker.position = CGPoint(x: self.size.width * 2 / 5, y: self.size.height/2)
        self.walker.size = CGSizeMake(self.walker.size.width * self.CHARA_SCALE, self.walker.size.height * self.CHARA_SCALE)
        self.walker.zPosition = 1.0
        
        myImage.position = self.walker.position
        myImage.zPosition = 2.0
        self.addChild(myImage)
        
        walker.physicsBody = SKPhysicsBody(texture: texture1, size: walker.frame.size)
        walker.physicsBody!.affectedByGravity = false
        walker.physicsBody!.restitution = 1.0
        walker.physicsBody!.linearDamping = 0
        walker.physicsBody!.friction = 0
        walker.physicsBody!.allowsRotation = false
        walker.physicsBody!.usesPreciseCollisionDetection = true
        walker.physicsBody?.categoryBitMask = WalkerCategory
        walker.physicsBody?.contactTestBitMask = WallCategory
        
//        self.walker.physicsBody = SKPhysicsBody(texture: texture1, size: walker.frame.size)
//        self.walker.physicsBody!.allowsRotation = false
//        self.walker.physicsBody?.categoryBitMask = WalkerCategory
//        self.walker.physicsBody?.contactTestBitMask = WallCategory
        self.world.addChild(walker)
        
        
        var Dwalk:SKAction = SKAction.animateWithTextures(textures1 as [AnyObject], timePerFrame: 0.2)
        var Lwalk:SKAction = SKAction.animateWithTextures(textures0 as [AnyObject], timePerFrame: 0.2)
        var Uwalk:SKAction = SKAction.animateWithTextures(textures3 as [AnyObject], timePerFrame: 0.2)
        var Rwalk:SKAction = SKAction.animateWithTextures(textures2 as [AnyObject], timePerFrame: 0.2)
        
        var Down:SKAction = SKAction.moveByX(0, y: -80, duration: 0.8)
        var Left:SKAction = SKAction.moveByX(-80, y: 0, duration: 0.8)
        var Up:SKAction = SKAction.moveByX(0, y: 80, duration: 0.8)
        var Right:SKAction = SKAction.moveByX(80, y: 0, duration: 0.8)
        
        shita = Down
        hidari = Left
        ue = Up
        migi = Right
        
        Dw = SKAction.repeatAction(Dwalk, count: 1)
        Lw = SKAction.repeatAction(Lwalk, count: 1)
        Uw = SKAction.repeatAction(Uwalk, count: 1)
        Rw = SKAction.repeatAction(Rwalk, count: 1)
    }
    
    func first(){
        switch(del.FirstPOS){
        case "FIRSTPOS 0":
            fmuki = 0
            muki = 0
            break
        case "FIRSTPOS 1":
            fmuki = 1
            muki = 1
            break
        case "FIRSTPOS 2":
            fmuki = 2
            muki = 2
            break
        case "FIRSTPOS 3":
            fmuki = 3
            muki = 3
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
        del.controller.sendMes(String(sender.tag))
    }

    internal func oncenterB(sender:UIButton){
        self.world.position = CGPointMake(-(self.walker.position.x - self.size.width * 2 / 5), -(self.walker.position.y - self.size.height/2))
        println(self.myImage.position)
        println(self.walker.position)
        println(self.world.position)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */

//        if atarimuki == soutai{
//            world.removeAllActions()
//            walker.removeActionForKey("cm2")
//            switch(atarimuki){
//            case 0:
//                walker.runAction(SKAction.moveByX(0, y: 10, duration: 0.2))
//                break
//            case 1:
//                walker.runAction(SKAction.moveByX(10, y: 0, duration: 0.2))
//                break
//            case 2:
//                walker.runAction(SKAction.moveByX(0, y: -10, duration: 0.2))
//                break
//            case 3:
//                walker.runAction(SKAction.moveByX(-10, y: 0, duration: 0.2))
//                break
//            default:
//                break
//            }
//
//            atarimuki = -1
//        }
        
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
            switch(soutai){
            case 0:
                cMove = Uw
                cMove2 = ue
                wMove = shita
                break
            case 1:
                cMove = Rw
                cMove2 = migi
                wMove = hidari
                break
            case 2:
                cMove = Dw
                cMove2 = shita
                wMove = ue
                break
            case 3:
                cMove = Lw
                cMove2 = hidari
                wMove = migi
                break
            default:
                break
            }

            if cFlag == false{
                cFlag = true
                walker.runAction(cMove, completion: {self.cFlag = false})
                walker.runAction(cMove2, withKey: "cm2")
                
//                if atarimuki != soutai{
//                    walker.runAction(cMove2, withKey: "cm2")
//                }else{
//                    atarimuki = -1
//                }
            }
            del.upflag = false
        }
    }
}
