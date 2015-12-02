//
//  Repulsor.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/14/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit
import CoreMotion

class Repulsor: SKNode {
    var overlayNode: SKShapeNode!
    var emitterNode: SKEmitterNode!
    var fieldNode: SKFieldNode!
    var motionManager = CMMotionManager()
    
    init(location: CGPoint) {
        fieldNode = SKFieldNode.radialGravityField()
        emitterNode = SKEmitterNode(fileNamed: "MyParticle")
        overlayNode = SKShapeNode(circleOfRadius: 15.0)
        
        super.init()
        
        fieldNode.strength = -5
        fieldNode.region = SKRegion(radius: 50.0)
        fieldNode.falloff = 4
        fieldNode.position = location
        
        self.addChild(fieldNode)
        
        emitterNode.position = location
        emitterNode.targetNode = self.scene
        
        self.addChild(emitterNode)
        
        let color = SKColor.blackColor()
        overlayNode.strokeColor = color
        overlayNode.fillColor = color
        overlayNode.position = location
        overlayNode.zPosition = 1
        
        self.addChild(overlayNode)
        
        motionManager.startDeviceMotionUpdates()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
