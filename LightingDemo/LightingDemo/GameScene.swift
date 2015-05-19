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
    var _lightSprite:SKSpriteNode?
    var _backgroundSprite1: SKSpriteNode?
    var _backgroundSprite2: SKSpriteNode?
    var _foregroundSprite1: SKSpriteNode?
    var _foregroundSprite2: SKSpriteNode?
    
    override func didMoveToView(view: SKView)
    {
        _screenH = view.frame.height
        _screenW = view.frame.width
        _scale = _screenW / 1920

        initBackground()
        initSprite()
        initLight()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            _lightSprite?.position = touch.locationInNode(self)
        }
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent)
    {
        for touch: AnyObject in touches {
            _lightSprite?.position = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval)
    {
        var y:CGFloat = _screenH / 2.0;
        
        var backgroundOffset: CGFloat = -CGFloat(Int(currentTime*100) % (1920*2));
        _backgroundSprite1?.position = CGPoint(x:_scale*((backgroundOffset < -1920) ? (3840+backgroundOffset) : backgroundOffset), y:y)
        _backgroundSprite2?.position = CGPoint(x:_scale*(1920+backgroundOffset), y:y)

        var foregroundOffset: CGFloat = -CGFloat(Int(currentTime*250) % (1920*2));
        _foregroundSprite1?.position = CGPoint(x:_scale*((foregroundOffset < -1920) ? (3840+foregroundOffset) : foregroundOffset), y:y)
        _foregroundSprite2?.position = CGPoint(x:_scale*(1920+foregroundOffset), y:y)
    }
    
    func initSprite()
    {
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
    }
    
    func initLight()
    {
        _lightSprite = SKSpriteNode(imageNamed: "Sprites/lightbulb.png")
        _lightSprite?.setScale(_scale * 2)
        _lightSprite?.position = CGPointMake(_screenW - 100, _screenH - 100)
        addChild(_lightSprite!);
        
        var light = SKLightNode();
        light.position = CGPointMake(0,0)
        light.falloff = 1
        light.ambientColor = UIColor.darkGrayColor()
        light.lightColor = UIColor.whiteColor()
        
        _lightSprite?.addChild(light)
    }
    
    func initBackground()
    {
        backgroundColor = SKColor.blackColor()
        _backgroundSprite1 = addBackgroundTile("Sprites/background_01.png");
        _backgroundSprite2 = addBackgroundTile("Sprites/background_01.png");
        _foregroundSprite1 = addForegroundTile("Sprites/foreground_01.png", normalsFile:"Sprites/foreground_01_n.png");
        _foregroundSprite2 = addForegroundTile("Sprites/foreground_02.png", normalsFile:"Sprites/foreground_02_n.png");
    }
    
    func addForegroundTile(spriteFile: String, normalsFile: String) -> SKSpriteNode
    {
        var foreground:SKSpriteNode
        
        foreground = SKSpriteNode(texture: SKTexture(imageNamed:spriteFile), normalMap: SKTexture(imageNamed:normalsFile));
        foreground.lightingBitMask = 1
        
        foreground.anchorPoint = CGPoint(x:0, y:0.5)
        foreground.setScale(_scale)
        addChild(foreground);
        
        return foreground;
    }

    func addBackgroundTile(spriteFile: String) -> SKSpriteNode
    {
        var background:SKSpriteNode

        background = SKSpriteNode(imageNamed:spriteFile);
        background.color = _light.ambientColor
        background.colorBlendFactor = 0.75
        
        background.anchorPoint = CGPoint(x:0, y:0.5)
        background.setScale(_scale)
        addChild(background);
        
        return background;
    }
}
