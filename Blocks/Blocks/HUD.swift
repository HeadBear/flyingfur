//
//  HUD.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/11/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import SpriteKit

class HUD: SKNode {
    var scoreBoard: SKLabelNode!
    var hudBar: SKSpriteNode!
    let kScoreBoardName = "scoreboard"
    let kHudBarName = "hudBar"
    var gameController: GameController!
    
    init(controller: GameController) {
        gameController = controller
        
        hudBar = SKSpriteNode(color: SKColor.clearColor(), size: CGSizeMake(UIScreen.mainScreen().bounds.size.width, 30.0))
        hudBar.name = kHudBarName
        hudBar.zPosition = 10
        hudBar.position = CGPointMake(0, UIScreen.mainScreen().bounds.size.height - 30)
        
        scoreBoard = SKLabelNode(text: "score: 0")
        scoreBoard.name = kScoreBoardName
        scoreBoard.fontName = "Chalkduster"
        scoreBoard.fontSize = 20.0
        scoreBoard.horizontalAlignmentMode = .Left
        scoreBoard.position = CGPointMake(0, 0)
        hudBar.addChild(scoreBoard)
        
        let padding = CGFloat(2.0)
        var ballPosition = hudBar.frame.size.width
        
        for i in 1...gameController.currentBallCount {
            let life = SKSpriteNode(imageNamed: "AvailableBall")
            life.name = "life\(i)"
            life.xScale = 0.5
            life.yScale = 0.5
            ballPosition -= life.frame.size.width + padding
            life.position = CGPointMake(ballPosition, 5)
            hudBar.addChild(life)
        }
        
        
        super.init()
        
        self.updateScoreBoard()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateScoreBoard() {
        let score = gameController.score
        scoreBoard.text = "score: \(score)"
        updateBallDisplay()
    }
    
    func updateBallDisplay() {
        for i in 1...gameController.defaultBallCount {
            
            if let life = hudBar.childNodeWithName("life\(i)") as? SKSpriteNode {
                
                if i <= gameController.currentBallCount {
                    life.texture = SKTexture(imageNamed: "AvailableBall")
                } else {
                    life.texture = SKTexture(imageNamed: "UsedBall")
                }
            }
        }
    }
}
