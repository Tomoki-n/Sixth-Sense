//
//  GameScene.swift
//  NSNL
//
//  Created by itsuki on 2015/08/20.
//  Copyright (c) 2015年 itsuki. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    
    let WalkerCategory: UInt32 = 0x1 << 1
    let WallCategory:UInt32 = 0x1 << 0
    let CHARA_SCALE:CGFloat = 1.2
    let R_SIZE:CGFloat = 31.0
    let C_SIZE:CGFloat = 24.0
    let MAP_COLS:CGFloat = 14.0
    let TILE_SIZE:CGFloat = 32.0
    let SCALE:CGFloat = 0.75
    var map_row:Int = 52
    var map_columm:Int = 48
    var map:[[String]] = []
    var phisic_map:[[String]] = []
    var tilesheet:SKTexture = SKTexture(imageNamed: "mapchip1")
    var world:SKSpriteNode!
    var actionFlag:Bool = false
    var fmuki:Int = 0
    var muki:Int = 0 // 0:上,1:右,2:下,3:左
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
    var wMove:SKAction!
    var cFlag:Bool = false
    var wFlag:Bool = false
    var scrView:UIScrollView!
    var button1:UIButton!
    var del: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
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
        
        self.physicsWorld.gravity = CGVectorMake(0, 0)
        if let csvPath = NSBundle.mainBundle().pathForResource("Mapdata1", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.map.append(line.componentsSeparatedByString(","))
            }
        }
        
        if let csvPath = NSBundle.mainBundle().pathForResource("physicdata1", ofType: "csv") {
            
            let csvString = NSString(contentsOfFile: csvPath, encoding: NSUTF8StringEncoding, error: nil) as! String
            csvString.enumerateLines { (line, stop) -> () in
                self.phisic_map.append(line.componentsSeparatedByString(","))
            }
        }
        
        scrView = UIScrollView()
        scrView.pagingEnabled = false
        scrView.frame = CGRectMake(self.size.width * 4 / 5, 0, self.size.width * 1 / 5, self.size.height)
        scrView.contentSize = CGSizeMake(self.size.width * 1 / 5, self.size.height * 2)
        scrView.backgroundColor = UIColor.blackColor()
        
        self.view?.addSubview(scrView)
        
        button1 = UIButton(frame: CGRectMake(0, 0, 40, 20))
        button1.backgroundColor = UIColor.whiteColor()
        scrView.addSubview(button1)
        
        world = SKSpriteNode()
        world.size = CGSizeMake(CGFloat(map_row) * TILE_SIZE, CGFloat(map_columm) * TILE_SIZE)
        world.zPosition = 0
        self.addChild(world!)
        
        //        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        //        myLabel.text = "Hello, World!";
        //        myLabel.fontSize = 65;
        //        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
        
        //        self.addChild(myLabel)
        Map_Create()
        Makewalker()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        actionFlag = true
    }
    
    func Map_Create(){
        for i in 0..<map_row{
            for j in 0..<map_columm{
                let p:Int = self.map[i][j].toInt()!
                let q:Int = self.phisic_map[i][j].toInt()!
                
                var x:CGFloat = CGFloat(CGFloat(p) % self.MAP_COLS * TILE_SIZE / tilesheet.size().width)
                var y:CGFloat = CGFloat(CGFloat(p) / self.MAP_COLS * TILE_SIZE / tilesheet.size().height)
                var w:CGFloat = CGFloat(TILE_SIZE / tilesheet.size().width)
                var h:CGFloat = CGFloat(TILE_SIZE / tilesheet.size().height)
                
                var Rect:CGRect = CGRectMake(x, y, w, h)
                var tile:SKTexture = SKTexture(rect: Rect, inTexture: self.tilesheet)
                var tileSprite:SKSpriteNode = SKSpriteNode(texture: tile)
                
                if q == 0{
                    tileSprite.physicsBody = SKPhysicsBody(texture: tile, size: tileSprite.frame.size)
                    
                    tileSprite.physicsBody!.dynamic = false
                    tileSprite.physicsBody?.categoryBitMask = WallCategory
                    tileSprite.physicsBody?.collisionBitMask = WalkerCategory
                    tileSprite.physicsBody?.contactTestBitMask = WallCategory | WalkerCategory
                }
                
                var position:CGPoint = CGPointMake(CGFloat(i) * self.TILE_SIZE, CGFloat(j) * self.TILE_SIZE)
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
        self.walker.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.walker.size = CGSizeMake(self.walker.size.width * self.CHARA_SCALE, self.walker.size.height * self.CHARA_SCALE)
        self.walker.zPosition = 1.0
        
        self.walker.physicsBody = SKPhysicsBody(texture: texture1, size: walker.frame.size)
        self.walker.physicsBody!.dynamic = false
        self.walker.physicsBody?.categoryBitMask = WalkerCategory
        self.walker.physicsBody?.contactTestBitMask = WallCategory
        self.addChild(walker)
        
        
        var Dwalk:SKAction = SKAction.animateWithTextures(textures1 as [AnyObject], timePerFrame: 0.2)
        var Lwalk:SKAction = SKAction.animateWithTextures(textures0 as [AnyObject], timePerFrame: 0.2)
        var Uwalk:SKAction = SKAction.animateWithTextures(textures3 as [AnyObject], timePerFrame: 0.2)
        var Rwalk:SKAction = SKAction.animateWithTextures(textures2 as [AnyObject], timePerFrame: 0.2)
        
        var Down:SKAction = SKAction.moveByX(0, y: -100, duration: 0.8)
        var Left:SKAction = SKAction.moveByX(-100, y: 0, duration: 0.8)
        var Up:SKAction = SKAction.moveByX(0, y: 100, duration: 0.8)
        var Right:SKAction = SKAction.moveByX(100, y: 0, duration: 0.8)
        
        shita = Down
        hidari = Left
        ue = Up
        migi = Right
        
        Dw = SKAction.repeatAction(Dwalk, count: 1)
        Lw = SKAction.repeatAction(Lwalk, count: 1)
        Uw = SKAction.repeatAction(Uwalk, count: 1)
        Rw = SKAction.repeatAction(Rwalk, count: 1)
        
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if actionFlag == true{
            
            if muki == 0{
                cMove = Uw
                wMove = shita
            }else if muki == 1{
                cMove = Rw
                wMove = hidari
            }else if muki == 2{
                cMove = Dw
                wMove = ue
            }else if muki == 3{
                cMove = Lw
                wMove = migi
            }
            if cFlag == false && wFlag == false{
                cFlag = true
                wFlag = true
                walker.runAction(cMove, completion: {self.cFlag = false})
                world.runAction(wMove, completion: {self.wFlag = false})
            }
            actionFlag = false
        }
    }
}
