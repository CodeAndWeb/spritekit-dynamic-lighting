//
//  GameScene.swift
//  LightingDemo
//
//  Created by Joachim Grill on 13.05.15.
//  Copyright (c) 2015 CodeAndWeb GmbH. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let light = SKLightNode()
    let label = SKLabelNode(fontNamed:"Chalkduster")
    
    var index = 0
    let sprites = [ "orange", "crate", "banana", "cherries" ]
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let background = SKSpriteNode(texture: SKTexture(imageNamed:"background"), normalMap: SKTexture(imageNamed:"background_n"))
        background.lightingBitMask = 1;
        background.position = CGPointMake(size.width/2, size.height/2)
        addChild(background)
        
        label.text = "Touch to create sprites!";
        label.position = CGPointMake(size.width/2, 60)
        addChild(label)
        
        light.position = CGPointMake(size.width/2, size.height/2)
        light.falloff = CGFloat(0.7)
        light.ambientColor = UIColor.darkGrayColor()
        light.lightColor = UIColor.lightGrayColor()
        addChild(light)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            if (index < 4)
            {
                let sprite = SKSpriteNode(texture: SKTexture(imageNamed:sprites[index]),
                                          normalMap: SKTexture(imageNamed: sprites[index] + "_n"))
            sprite.position = location
                sprite.lightingBitMask = 1;
                addChild(sprite)
                index++;
                if (index == 4)
                {
                    label.text = "Touch to move light!";
                }
            }
            else
            {
                light.position = location
            }
        }
    }
            
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            light.position = location
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
