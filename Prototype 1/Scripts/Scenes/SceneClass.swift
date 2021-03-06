//
//  SceneClass.swift
//  Prototype 1
//
//  Created by Huu Nguyen on 17/5/19.
//  Copyright © 2019 Siou-Wun Chen. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// set scene interaction with cards
class SceneClass: SKScene {
    
    var currentCard: CardTemplate?
    var deck: CardDeck?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // select card on first touch
        if let touch = touches.first {
            // set current touch
            let location = touch.location(in: self)
            if let card = atPoint(location) as? CardTemplate {
                currentCard = card
            }
                // check for card child i.e the card image, and do silimar thing as above
            else if let card = atPoint(location).parent as? CardTemplate {
                currentCard = card
            }
            // change the card floating height
            currentCard?.zPosition = CardLevel.moving.rawValue
            // remove the drop action
            currentCard?.removeAction(forKey: "drop")
            // run the card enlargement animation
            currentCard?.run(SKAction.scale(to: 1.3, duration: 0.25), withKey: "pickup")
        }
    }
    // move the card when the touch position change
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchedPoint = touches.first!
        let pointToMove = touchedPoint.location(in: self)
        // animation for card movement
        let moveAction = SKAction.move(to: pointToMove, duration: 0.1)
        if currentCard != nil {
            currentCard?.run(moveAction,withKey: "move")
        }
    }
    
    // "drop" the card when the touch end
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            // use the first touch
            // select the card
            if currentCard != nil {
                // change the card floating height
                currentCard?.zPosition = CardLevel.board.rawValue
                // remove the pickup action
                currentCard?.removeAction(forKey: "pickup")
                // run the card drop animation
                currentCard?.run(SKAction.scale(to: 1.0, duration: 0.25), withKey: "drop")
                currentCard = nil
            }
        }
    }
}
