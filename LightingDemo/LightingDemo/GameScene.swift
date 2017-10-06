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
    var _lightSprite:SKSpriteNode?
    var _backgroundSprite1: SKSpriteNode?
    var _backgroundSprite2: SKSpriteNode?
    var _foregroundSprite1: SKSpriteNode?
    var _foregroundSprite2: SKSpriteNode?
    var _ambientColor:UIColor?
    
    override func didMove(to view: SKView)
    {
        _screenH = view.frame.height
        _screenW = view.frame.width
        _scale = _screenW / 1920

        _ambientColor = UIColor.darkGray

        initBackground()
        initSprite()
        initLight()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            _lightSprite?.position = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch: AnyObject in touches {
            _lightSprite?.position = touch.location(in: self)
        }
    }
   
    override func update(_ currentTime: TimeInterval)
    {
        let y:CGFloat = _screenH / 2.0;
        
        let backgroundOffset: CGFloat = -CGFloat(Int(currentTime*100) % (1920*2));
        _backgroundSprite1?.position = CGPoint(x:_scale*((backgroundOffset < -1920) ? (3840+backgroundOffset) : backgroundOffset), y:y)
        _backgroundSprite2?.position = CGPoint(x:_scale*(1920+backgroundOffset), y:y)

        let foregroundOffset: CGFloat = -CGFloat(Int(currentTime*250) % (1920*2));
        _foregroundSprite1?.position = CGPoint(x:_scale*((foregroundOffset < -1920) ? (3840+foregroundOffset) : foregroundOffset), y:y)
        _foregroundSprite2?.position = CGPoint(x:_scale*(1920+foregroundOffset), y:y)
    }
    
    fileprivate func initSprite()
    {
        var animFrames = [SKTexture]()
        var normals = [SKTexture]()
        for index in 1...8 {
            animFrames.append(SKTexture(imageNamed: String(format:"Sprites/character/%02d.png", index)))
            normals.append(SKTexture(imageNamed: String(format:"Sprites/character/%02d_n.png", index)))
        }
        
        let sprite = SKSpriteNode(texture: animFrames[0], normalMap: normals[0])
        
        let fps = 8.0

        let anim = SKAction.customAction(withDuration: 1.0, actionBlock: { node, time in
            let index = Int((fps * Double(time))) % animFrames.count
            (node as! SKSpriteNode).normalTexture = normals[index]
            (node as! SKSpriteNode).texture = animFrames[index]
        })
        sprite.run(SKAction.repeatForever(anim));
        
        sprite.position = CGPoint(x: _screenW / 2, y: _screenH / 2 - 75.0 * _scale)
        sprite.setScale(_scale)
        sprite.lightingBitMask = 1
        
        addChild(sprite)
    }
    
    fileprivate func initLight()
    {
        _lightSprite = SKSpriteNode(imageNamed: "Sprites/lightbulb.png")
        _lightSprite?.setScale(_scale * 2)
        _lightSprite?.position = CGPoint(x: _screenW - 100, y: _screenH - 100)
        addChild(_lightSprite!);
        
        let light = SKLightNode();
        light.position = CGPoint(x: 0,y: 0)
        light.falloff = 1
        light.ambientColor = _ambientColor!
        light.lightColor = UIColor.white
        
        _lightSprite?.addChild(light)
    }
    
    fileprivate func initBackground()
    {
        backgroundColor = SKColor.black
        _backgroundSprite1 = addBackgroundTile("Sprites/background_01.png");
        _backgroundSprite2 = addBackgroundTile("Sprites/background_01.png");
        _foregroundSprite1 = addForegroundTile("Sprites/foreground_01.png", normalsFile:"Sprites/foreground_01_n.png");
        _foregroundSprite2 = addForegroundTile("Sprites/foreground_02.png", normalsFile:"Sprites/foreground_02_n.png");
    }
    
    fileprivate func addForegroundTile(_ spriteFile: String, normalsFile: String) -> SKSpriteNode
    {
        var foreground:SKSpriteNode
        
        foreground = SKSpriteNode(texture: SKTexture(imageNamed:spriteFile), normalMap: SKTexture(imageNamed:normalsFile));
        foreground.lightingBitMask = 1
        
        foreground.anchorPoint = CGPoint(x:0, y:0.5)
        foreground.setScale(_scale)
        addChild(foreground);
        
        return foreground;
    }

    fileprivate func addBackgroundTile(_ spriteFile: String) -> SKSpriteNode
    {
        var background:SKSpriteNode

        background = SKSpriteNode(imageNamed:spriteFile);
        background.color = _ambientColor!
        background.colorBlendFactor = 0.75
        
        background.anchorPoint = CGPoint(x:0, y:0.5)
        background.setScale(_scale)
        addChild(background);
        
        return background;
    }
}
