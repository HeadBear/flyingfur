//
//  File.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/1/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class block: SKSpriteNode {
    var hitCount = 0
    let blockWidth = 8.0
    let blockHeight = 4.0
    let blockStrokeColor = SKColor.redColor()
    let blockFillColor = SKColor.redColor()
    var centerPoint: CGPoint
    let contactCategory = CollisionCategories.Block
    let blockName: String
    
    init(location: CGPoint, name: String) {
        centerPoint = location
        blockName = name
        
        let texture = SKTexture(imageNamed: "Block")
        
        let xDelta = Double(texture.size().width / 2) + Double(centerPoint.x)
        let yDelta = Double(texture.size().height / 2) + Double(centerPoint.y)
        let moveAction = SKAction.moveTo(CGPoint(x: xDelta, y: yDelta), duration: 0.0)
        
        
        super.init(texture: texture, color: SKColor.clearColor(), size: texture.size())
        
        self.physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        self.physicsBody?.usesPreciseCollisionDetection = false
        self.physicsBody?.categoryBitMask = CollisionCategories.Block
        self.physicsBody?.contactTestBitMask = CollisionCategories.Ball
        self.physicsBody?.collisionBitMask = 0x0
        self.physicsBody?.friction = 0.0
        self.physicsBody?.dynamic = false
        
        
        self.runAction(moveAction)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
