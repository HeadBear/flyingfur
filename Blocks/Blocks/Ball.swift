//
//  Ball.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/1/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class Ball: SKSpriteNode {
    let radius: CGFloat = 8.0
    
    init() {
        let texture = SKTexture(imageNamed: "BlocksBall")
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        self.name = "ball"
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: texture.size().height / 2)
        self.physicsBody?.friction = 0.0
        self.physicsBody?.restitution = 1.0
        self.physicsBody?.linearDamping = 0.0
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Ball
        self.physicsBody?.contactTestBitMask = CollisionCategories.Block
        self.physicsBody?.affectedByGravity = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}