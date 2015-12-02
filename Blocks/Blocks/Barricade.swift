//
//  Barricade.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/8/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class Barricade: SKSpriteNode {
    init(location: CGPoint, name: String){
        
        let texture = SKTexture(imageNamed: "Barricade")
        
        let xDelta = Double(texture.size().width) + Double(location.x)
        let yDelta = Double(texture.size().height) + Double(location.y)
        let moveAction = SKAction.moveTo(CGPoint(x: xDelta, y: yDelta), duration: 0.0)
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
//        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody = SKPhysicsBody(texture: texture, size: CGSizeMake(texture.size().width, texture.size().height * 4))
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.physicsBody?.categoryBitMask = CollisionCategories.Barricade
        self.physicsBody?.contactTestBitMask = CollisionCategories.Ball
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.friction = 0.0
        
        self.runAction(moveAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
