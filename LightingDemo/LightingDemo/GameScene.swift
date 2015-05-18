//
//  GameScene.swift
//  LightingDemo
//
//  Created by Joachim Grill on 13.05.15.
//  Copyright (c) 2015 CodeAndWeb GmbH. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var _scale: CGFloat = 1.0
    var _screenH: CGFloat = 640.0
    var _screenW: CGFloat = 960.0
    let _fps = 8.0
    let _light = SKLightNode()
    var _lightSprite = SKSpriteNode(imageNamed: "Sprites/lightbulb.png")
    
    override func didMoveToView(view: SKView) {
        
        _screenH = view.frame.height
        _screenW = view.frame.width
        _scale = _screenW / 1920

        _light.position = CGPointMake(_screenW - 100, _screenH - 100)
        _light.falloff = 1
        _light.ambientColor = UIColor.darkGrayColor()
        _light.lightColor = UIColor.whiteColor()
        addChild(_light)

        initBackground()
        
        var animFrames = [SKTexture]()
        var normals = [SKTexture]()
        for index in 1...8 {
            animFrames.append(SKTexture(imageNamed: String(format:"Sprites/character/%02d.png", index)))
            normals.append(SKTexture(imageNamed: String(format:"Sprites/character/%02d_n.png", index)))
    }
        let sprite = SKSpriteNode(texture: animFrames[0], normalMap: normals[0])
    
        let anim = SKAction.customActionWithDuration(1.0, actionBlock: { node, time in
            let index = Int((self._fps * Double(time))) % animFrames.count
            (node as! SKSpriteNode).normalTexture = normals[index]
            (node as! SKSpriteNode).texture = animFrames[index]
        })
        sprite.runAction(SKAction.repeatActionForever(anim));
        
        sprite.position = CGPoint(x: _screenW / 2, y: _screenH / 2 - 75.0 * _scale)
        sprite.setScale(_scale)
        sprite.lightingBitMask = 1
            
                addChild(sprite)
        
        _lightSprite.position = _light.position
        _lightSprite.setScale(_scale * 2)
        addChild(_lightSprite);
            }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            _light.position = touch.locationInNode(self)
            _lightSprite.position = _light.position
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            _light.position = touch.locationInNode(self)
            _lightSprite.position = _light.position
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func initBackground()
    {
        backgroundColor = SKColor.blackColor()
        addBackgroundTile("Sprites/background_01.png", offsetX:0,    speed:50);
        addBackgroundTile("Sprites/background_01.png", offsetX:1920, speed:50);
        addBackgroundTile("Sprites/foreground_01.png", offsetX:0,    speed:100, normalsFile:"Sprites/foreground_01_n.png");
        addBackgroundTile("Sprites/foreground_02.png", offsetX:1920, speed:100, normalsFile:"Sprites/foreground_02_n.png");
    }
    
    
    func addBackgroundTile(spriteFile: String, offsetX: CGFloat, speed: CGFloat, normalsFile: String = "")
    {
        var background:SKSpriteNode
        if (normalsFile != "")
        {
            background = SKSpriteNode(texture: SKTexture(imageNamed:spriteFile), normalMap: SKTexture(imageNamed:normalsFile));
            background.lightingBitMask = 1
        }
        else
        {
            background = SKSpriteNode(imageNamed:spriteFile);
            background.color = _light.ambientColor
            background.colorBlendFactor = 0.75
        }
        
        let scaledOffsetX = offsetX * _scale
        let scaledOffsetY = (_screenH - background.size.height * _scale) / 2.0
        
        background.anchorPoint = CGPoint(x:0, y:0)
        background.setScale(_scale)
        addChild(background);
        
        let a1 = SKAction.moveTo(CGPoint(x:scaledOffsetX, y:scaledOffsetY), duration:0)
        let a2 = SKAction.moveToX(-_screenW,     duration:Double((_screenW + scaledOffsetX) / speed));
        let a3 = SKAction.moveToX(_screenW,      duration:0)
        let a4 = SKAction.moveToX(scaledOffsetX, duration:Double((_screenW - scaledOffsetX) / speed));

        background.runAction(SKAction.repeatActionForever(SKAction.sequence([a1, a2, a3, a4])));
    }
}
