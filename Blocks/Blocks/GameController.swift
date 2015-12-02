//
//  GameController.swift
//  Blocks
//
//  Created by Chris Jarvi on 11/2/15.
//  Copyright © 2015 Flying Fur Development. All rights reserved.
//

import Foundation
import SpriteKit

class GameController {
    var score = 0
    let pointPerBlockHit: Int
    var blocksCount: Int
    var triggeredBlocks = Dictionary<String,String>()
    var currentBallCount = 6
    let defaultBallCount = 6
    var gameOver = false
    var gameWon = false
    var ballIsInPlay = false
    var hitsThisBall = 0
    
    init(pointPerHit: Int, blockCount: Int) {
        pointPerBlockHit = pointPerHit
        blocksCount = blockCount
        currentBallCount = defaultBallCount
    }
    
    func recordHit(blockName: String) -> Bool {
        if (triggeredBlocks[blockName] == nil) {
            triggeredBlocks[blockName] = blockName
            score += pointPerBlockHit
            blocksCount -= 1
            hitsThisBall++
            
            if blocksCount == 0 {
                gameWon = true
                return true
            }
        }
        return false
    }
    
    func getScore() -> Int {
        return score
    }
    
    func ballLeftPlay() -> Bool {
        ballIsInPlay = false
        hitsThisBall = 0
        if currentBallCount == 0 {
            return true
        }
        return false
    }
    
    func resetBall() {
        ballIsInPlay = false
        if hitsThisBall == 0 {
            currentBallCount++
        }
        
    }
    
    func ballEnteredPlay() {
        ballIsInPlay = true
        currentBallCount--
    }
    
    func triggerGameOver()
    {
        gameOver = true
    }
}