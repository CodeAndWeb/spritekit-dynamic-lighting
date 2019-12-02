//
//  GameViewController.swift
//  LightingDemo
//
//  Created by Joachim Grill on 13.05.15.
//  Copyright (c) 2019 CodeAndWeb GmbH. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    fileprivate func setup() {
        guard let skView = self.view as? SKView else { return }
        let scene = GameScene(size: self.view.bounds.size)
        scene.scaleMode = .aspectFill //.aspectFit
        scene.isPaused = false
        scene.speed = 1.0
        skView.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
    }
}
