//
//  GameOverScene.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/13/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    var score = 0
    var gameWon = false
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.fontName = "Chalkduster"
        gameOverLabel.fontSize = 20
        gameOverLabel.horizontalAlignmentMode = .Left
        
        let x = (self.frame.width / 2) - (gameOverLabel.frame.width / 2)
        let y = (self.frame.height / 2)
        gameOverLabel.position = CGPointMake(x, y)
        
        self.addChild(gameOverLabel)
        
        let scoreLabel = SKLabelNode(text: "Score: \(score)")
        scoreLabel.fontName = "Chalkduster"
        scoreLabel.fontSize = 20
        scoreLabel.horizontalAlignmentMode = .Left
        scoreLabel.position = CGPointMake(x, y + gameOverLabel.frame.height)
        
        self.addChild(scoreLabel)
        
        let action = {() -> Void in
            let gameScene = GameScene()
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
            gameScene.scaleMode = .ResizeFill
            view.presentScene(gameScene, transition: transition)
        }
        
        if let startButton = Button(defaultButtonImage: "BlockStartButtonDefault", activeButtonImage: "BlockStartButtonActive", buttonAction: action) {
            startButton.position = CGPointMake(self.frame.width / 2, self.frame.height * 0.25)
            startButton.zPosition = 1
            self.addChild(startButton)
        }
        
        let woohooLabel = SKLabelNode(text: "woohoo sound effect from pacdev.com")
        let sfxLabel = SKLabelNode(text: "all other sound effects from soundbible.com")
        
        sfxLabel.position = CGPointMake(10.0, 5.0)
        sfxLabel.fontName = "Chalkduster"
        sfxLabel.fontSize = 10.0
        sfxLabel.horizontalAlignmentMode = .Left
        self.addChild(sfxLabel)
        
        woohooLabel.position = CGPointMake(10.0, 5.0 + sfxLabel.frame.height)
        woohooLabel.fontName = "Chalkduster"
        woohooLabel.fontSize = 10.0
        woohooLabel.horizontalAlignmentMode = .Left
        self.addChild(woohooLabel)
        
        let soundfile = gameWon ? "woohoo.wav" : "Evil_Laugh_Male_6-Himan-1359990674.mp3"
        runAction(SKAction.playSoundFileNamed(soundfile, waitForCompletion: false))
        
    }
}
