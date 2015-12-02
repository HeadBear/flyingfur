//
//  OpeningScene.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/11/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class OpeningScene: SKScene {
    override func didMoveToView(view: SKView) {
        let background = SKSpriteNode(imageNamed: "bg")
        background.position = CGPointMake(self.frame.width / 2, self.frame.height / 2)
        background.size = self.frame.size
        self.addChild(background)
        
        let action = {() -> Void in
            let instructions = Instructions()
            let transition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.5)
            instructions.scaleMode = .ResizeFill
            view.presentScene(instructions, transition: transition)
        }
        
        if let startButton = Button(defaultButtonImage: "BlockStartButtonDefault", activeButtonImage: "BlockStartButtonActive", buttonAction: action) {
            startButton.position = CGPointMake(0, background.frame.height * -0.25)
            startButton.zPosition = 1
            background.addChild(startButton)
        }
        
        
    }
}
