//
//  GameScene.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/1/15.
//  Copyright (c) 2015 Flying Fur Development. All rights reserved.
//

import SpriteKit

struct CollisionCategories {
    static let Ball : UInt32 = 0x1 << 0
    static let Block : UInt32 = 0x1 << 1
    static let Border : UInt32 = 0x1 << 2
    static let Barricade : UInt32 = 0x1 << 3
    static let Background : UInt32 = 0x1 << 4
}


class GameScene: SKScene, SKPhysicsContactDelegate  {
    var gameController: GameController!
    var touchStartPoint: CGPoint!
    var touchStartTime: NSTimeInterval!
    let kMinTouchDistance = 25.0
    let kMinDuration = 0.1
    let kMinSpeed = 580.0
    let kMaxSpeed = 600.0
    let kBallName = "ball"
    var ballVelocity : CGVector!
    var hudNode: HUD!
    var touchIsGood = false
    let yRepulsor: CGFloat = 50.0
    var repulsorNode: Repulsor!
    var restStartTime: NSDate!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = SKColor.blackColor()
        
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0)
        self.physicsWorld.contactDelegate = self
        
        self.physicsBody?.categoryBitMask = CollisionCategories.Background
        self.physicsBody?.collisionBitMask = 0x0
        
        self.physicsBody?.friction = 0.0
        self.physicsBody = self.createPhysicsBorder()
        
        let boxArray = boxes()
        
        for (_, box) in boxArray.enumerate() {
            self.addChild(box)
        }
        
        gameController = GameController(pointPerHit: 10, blockCount: boxArray.count)
        
        hudNode = HUD(controller: gameController)
        self.addChild(hudNode.hudBar)
        
        createBarricades()
        
        repulsorNode = Repulsor(location: CGPointMake(0.0, yRepulsor))
        self.addChild(repulsorNode)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        if touches.count > 1 {
            touchIsGood = false
            return
        }
        
        if gameController.currentBallCount <= 0 {
            touchIsGood = false
            return
        }
        
        if let _ = self.childNodeWithName(kBallName) as? Ball  {
            //ball is in play.  don't add another
            touchIsGood = false
            return;
        }
        
        touchStartPoint = touches.first?.locationInNode(self)
        touchStartTime = touches.first?.timestamp
        
        let ball = Ball()
        ball.position = touchStartPoint
        self.addChild(ball)
        
        //check if ball was actually added - SpriteKit bug?
        guard let _ = self.childNodeWithName(kBallName) else {
            self.addChild(ball)
            touchIsGood = true
            return
        }
        touchIsGood = true
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if touchIsGood == false {
            //either ball is already in play, there was more than one touch point, or the ball count was zero
            return
        }
        
        if let touch = touches.first {
            let touchEndPoint = touch.locationInNode(self)
            let xDelta = touchEndPoint.x - touchStartPoint.x
            let yDelta = touchEndPoint.y - touchStartPoint.y
            let speed = calculateSpeed(CGVector(dx: xDelta, dy: yDelta))
            guard let ball = self.childNodeWithName(kBallName) as? Ball else {
                return
            }
            
            if speed < CGFloat(kMinSpeed) {
                let ratio = CGFloat(kMinSpeed)/speed
                let vector = CGVectorMake(xDelta * CGFloat(ratio), yDelta * CGFloat(ratio))
                ball.physicsBody?.applyForce(vector)
            } else if speed > CGFloat(kMaxSpeed) {
                let ratio = CGFloat(kMaxSpeed) / speed
                let vector = CGVectorMake(ballVelocity.dx * ratio, ballVelocity.dy * ratio)
                ball.physicsBody?.applyForce(vector)
            } else {
                let vector = CGVectorMake(xDelta, yDelta)
                ball.physicsBody?.applyForce(vector)
            }
            gameController.ballEnteredPlay()
            hudNode.updateBallDisplay()
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if let motion = repulsorNode.motionManager.deviceMotion {
            let gravityMultiple = 200.0
            let centerpoint = CGPointMake(self.frame.width / 2, 150.0)
            let gravity = motion.gravity
            let xDelta = CGFloat(gravity.x * gravityMultiple)
            let location = CGPointMake(centerpoint.x + xDelta, 150.0)
            repulsorNode.position = location
        }
        
        guard let ball = self.childNodeWithName(kBallName) as? Ball else {
            return
        }
        
        if ball.position.x < 0.0 || ball.position.x > self.frame.width ||
            ball.position.y < -10.0 || ball.position.y > self.frame.height {
                ball.removeFromParent()
                runAction(SKAction.playSoundFileNamed("flyby-Conor-1500306612.mp3", waitForCompletion: false))
                if gameController.ballLeftPlay() {
                    self.showGameOver()
                }
                return
        }
        
        if let ballPhysics = ball.physicsBody {
            let speed = calculateSpeed(ballPhysics.velocity)
            
            if speed > CGFloat(kMaxSpeed) {
                ballPhysics.linearDamping = 0.8
            } else if speed < CGFloat(kMinSpeed) {
                ballPhysics.applyAngularImpulse(CGFloat(kMinSpeed) - speed)
            } else {
                ballPhysics.linearDamping = 0.0
                ballPhysics.friction = 0.0
            }
            
            if speed == 0 {
                if restStartTime == nil {
                    restStartTime = NSDate()
                } else {
                    if NSDate().timeIntervalSinceDate(restStartTime) > 3.0 {
                        ball.removeFromParent()
                        gameController.resetBall()
                        restStartTime = nil
                    }
                }
            } else {
                restStartTime = nil
            }
        }
        
        
    }
    
    func boxes () -> Array<block> {
        var boxArray = Array<block>()
        let yStart = 550.0
        let boxWidth = 8.0
        
        for row in 1...4 {
            var startOffset = row % 2 == 0 ? true : false
            let yPos = yStart - (Double(row) * 30.0)
            
            let segment = Int(Double(self.frame.width)/boxWidth)  //screen width / box width
            
            for x in 0..<segment {
                if x % 4 == 0 {
                    startOffset = !startOffset
                }
                if !startOffset {
                    let blk = block(location: CGPoint(x: Double(x) * boxWidth, y: yPos), name: "block \(row) \(x)")
                    boxArray.append(blk)
                }
            }
        }
        
        return boxArray
    }
    
    func createPhysicsBorder() -> SKPhysicsBody {
        let height = self.frame.height
        let width: CGFloat = self.frame.width
        
        let borderPoints = [CGPointMake(0.0, 0.0),
                            CGPointMake(0.0, height),
                            CGPointMake(width, height),
                            CGPointMake(width, 0.0)]
        
        let path = CGPathCreateMutable()
        CGPathAddLines(path, nil, borderPoints, 4)
        let physicsBody = SKPhysicsBody(edgeChainFromPath: path)
        physicsBody.friction = 0.0
        physicsBody.restitution = 1.0
        physicsBody.linearDamping = 0.0
        physicsBody.angularDamping = 0.0
        physicsBody.categoryBitMask = CollisionCategories.Border
        physicsBody.usesPreciseCollisionDetection = true
        physicsBody.contactTestBitMask = CollisionCategories.Ball
        physicsBody.collisionBitMask = 0x0
        physicsBody.dynamic = false
        
        return physicsBody
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if (firstBody.categoryBitMask & CollisionCategories.Ball != 0) && (secondBody.categoryBitMask & CollisionCategories.Block != 0) {
            let hitBlock = secondBody.node as! block
            let sound = SKAction.playSoundFileNamed("Water Droplet-SoundBible.com-854529508.mp3", waitForCompletion: false)
            runAction(sound)
            if gameController.recordHit(hitBlock.blockName) == true {
                hitBlock.removeFromParent()
                hudNode.updateScoreBoard()
                self.childNodeWithName("ball")?.removeFromParent()
                self.showGameOver()
                return
            }
            hitBlock.removeFromParent()
            hudNode.updateScoreBoard()
            
        }
        
        if (firstBody.categoryBitMask & CollisionCategories.Ball != 0) && (secondBody.categoryBitMask & CollisionCategories.Border != 0) {
        }
    }
    
    func showGameOver() {
        let gameOverScene = GameOverScene()
        gameOverScene.score = gameController.score
        gameOverScene.gameWon = gameController.gameWon
        gameOverScene.scaleMode = .ResizeFill
        let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Up, duration: 0.5)
        self.view?.presentScene(gameOverScene, transition: transition)
    }
    
    func createBarricades() {
        let barricadeCount = 4
        for i in 1...barricadeCount {
            let barricade = Barricade(location: CGPointMake(CGFloat(i-1) * 0.25 * self.frame.width, 0.0), name: "barricade\(i)")
            self.addChild(barricade)
        }
    }
    
    func calculateSpeed(velocity: CGVector) -> CGFloat {
        return sqrt(pow(velocity.dx, 2.0) + pow(velocity.dy, 2.0))
    }
}
