//
//  Button.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/10/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

// code from http://nathandemick.com/programming/tutorial/2014/09/23/buttons-sprite-kit-using-swift.html

import SpriteKit

class Button: SKNode {
    var defaultButton: SKSpriteNode
    var activeButton: SKSpriteNode
    var action: () -> Void
    
    init?(defaultButtonImage: String, activeButtonImage: String, buttonAction:() -> Void) {
        defaultButton = SKSpriteNode(imageNamed: defaultButtonImage)
        activeButton = SKSpriteNode(imageNamed: activeButtonImage)
        activeButton.hidden = true
        action = buttonAction
        
        super.init()
        
        userInteractionEnabled = true
        addChild(defaultButton)
        addChild(activeButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        activeButton.hidden = false
        defaultButton.hidden = true
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            activeButton.hidden = false
            defaultButton.hidden = true
        } else {
            activeButton.hidden = true
            defaultButton.hidden = false
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        let location = touch.locationInNode(self)
        
        if defaultButton.containsPoint(location) {
            action()
        }
    }
}
