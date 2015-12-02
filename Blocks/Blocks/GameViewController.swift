//
//  GameViewController.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/1/15.
//  Copyright (c) 2015 Flying Fur Development. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let openingScene = OpeningScene()
        openingScene.size = UIScreen.mainScreen().bounds.size
        let gameView = view as! SKView
//        gameView.showsFPS = true
//        gameView.showsNodeCount = true
        gameView.ignoresSiblingOrder = true
//        gameView.showsPhysics = true
        openingScene.scaleMode = .ResizeFill
        gameView.presentScene(openingScene)
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
