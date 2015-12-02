//
//  Instructions.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/14/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class Instructions: SKScene {
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor.blackColor()
        let fontName = "Chalkduster"
        let fontSize: CGFloat = 20.0
        let fontColor = SKColor.whiteColor()
        let xPos: CGFloat = self.frame.width / 2
        var yPos: CGFloat = self.frame.height - 100.0
        
        let textArray = ["You have 6 lives to hit",
            "as many blocks as you can.",
            "",
            "To get the ball moving,",
            "perform a flick gesture on",
            "the screen.  This will shoot",
            "the ball in the direction",
            "you flick.",
            "",
            "In the bottom half of the",
            "screen you'll see a repulsor",
            "field which you can use",
            "deflect the ball.",
            "To move it, tilt your screen",
            "to the left or right."]
        
        for i in 0..<textArray.count {
            let label = SKLabelNode(text: textArray[i])
            label.fontName = fontName
            label.fontColor = fontColor
            label.fontSize = fontSize
            label.horizontalAlignmentMode = .Center
            label.position = CGPointMake(xPos, yPos)
            self.addChild(label)
            
            yPos -= 25.0
        }
        
        let action = {() -> Void in
            let gameScene = GameScene()
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
            gameScene.scaleMode = .ResizeFill
            view.presentScene(gameScene, transition: transition)
        }
        
        if let startButton = Button(defaultButtonImage: "BlockStartButtonDefault", activeButtonImage: "BlockStartButtonActive", buttonAction: action) {
            let yDelta = min(self.frame.height * 0.25, yPos)
            startButton.position = CGPointMake(self.frame.width / 2, yDelta)
            startButton.zPosition = 1
            self.addChild(startButton)
        }
    }
}