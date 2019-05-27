//
//  CardTemplate.swift
//  Prototype 1
//
//  Created by 胡健妮 on 16/5/19.
//  Copyright © 2019 Siou-Wun Chen. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

enum CardType: Int {
    case attack,
         heal,
         buff,
         debuff
}


enum CardLevel: CGFloat {
    case board = 10
    case moving = 100
    case enlarged = 200
}


// 1
class CardTemplate: SKSpriteNode {

    let cardType: CardType
    let frontTexture: SKTexture
    let backTexture: SKTexture
    var chosen: Bool = false
    var cardSize: CGSize
    var enlarged = false
    var savedPosition = CGPoint.zero
    var chosenCard = [Int]()

    // node
    var energyNode = SKLabelNode(fontNamed: "Chalkduster")
    var nameNode = SKLabelNode(fontNamed: "Chalkduster")
    var imageNode = SKSpriteNode(imageNamed: "CardAttackImage1")
    var descNode = SKLabelNode(fontNamed: "Chalkduster")

    // card attribute
    private var energy: Int = 1
    private var cardName: String = ""
    private var cardDescription: String = ""
    private var cardImage: String = ""

    init(cardType: CardType) {
        self.cardType = cardType
        backTexture = SKTexture(imageNamed: "CardBackgroundShadow")
        self.cardSize = CGSize.init(width: 130, height: 190)
        switch cardType {
        case .attack:
            frontTexture = SKTexture(imageNamed: "CardAttack")
        case .heal:
            frontTexture = SKTexture(imageNamed: "CardHeal")
        case .buff:
            frontTexture = SKTexture(imageNamed: "CardBuff")
        case .debuff:
            frontTexture = SKTexture(imageNamed: "CardDeBuff")
        }
        super.init(texture: frontTexture, color: .clear, size: cardSize)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ){
        self.physicsBody = SKPhysicsBody(rectangleOf: self.cardSize)
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = Physics.card
        self.physicsBody?.contactTestBitMask = Physics.enemy
        self.physicsBody?.collisionBitMask = Physics.none
        //        }

        //        super.init(texture: frontTexture, color: .clear, size: cardSize)
        self.initialUINode()
    }

//    convenience init(cardType: CardType, name: String, energy: Int, imageName: String) {
//        self.init(cardType: cardType)
//        setName(with: name)
//        setEnergy(with: energy)
//        setImage(with: imageName)
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }

    func initialUINode() {
        print("show")
//        energyNode.text = "1"
        energyNode.fontSize = 15
        energyNode.fontColor = SKColor.white
        energyNode.position = CGPoint(x: -50, y: 70)
        energyNode.preferredMaxLayoutWidth = 110
        super.addChild(energyNode)

        nameNode.fontSize = 13
        nameNode.fontColor = SKColor.black
        nameNode.position = CGPoint(x: 0, y: -20)
        nameNode.preferredMaxLayoutWidth = 90
        super.addChild(nameNode)

        descNode.fontSize = 13
        descNode.fontColor = SKColor.black
        descNode.preferredMaxLayoutWidth = 100
        descNode.numberOfLines = 2
        descNode.horizontalAlignmentMode = .center
        descNode.position = CGPoint(x: 0, y: -(190 / 4 ))
        descNode.verticalAlignmentMode = .top
        super.addChild(descNode)

        imageNode = SKSpriteNode(imageNamed: "CardAttackImage1")
        imageNode.position = CGPoint(x: 0, y: 35)
        imageNode.zPosition = -1
//        imageNode.zPosition = -1
        super.addChild(imageNode)


    }

    func setEnergy(with value: Int) {
        energyNode.text = "\(value)"
        self.energy = value
    }

    func getEnergy() -> Int {
        return self.energy
    }

    func setName(with value: String) {
        nameNode.text = "\(value)"
        self.cardName = value
    }

    func getName() -> String {
        return self.cardName
    }

    func setDescription(with value: String) {
        descNode.text = "\(value)"
        self.cardDescription = value
    }

    func getDescription() -> String {
        return self.cardDescription
    }

    func setImage(with fileName: String) {
        self.cardImage = fileName
        imageNode = SKSpriteNode(imageNamed: fileName)
        imageNode.position = CGPoint(x: 0, y: 35)
        imageNode.zPosition = -1
//        imageNode.isUserInteractionEnabled = false
    }

    func getImageName() -> String {
        return self.cardImage
    }

    func activateCard() {

    }

    func enlarge() {
        if enlarged {
            let slide = SKAction.move(to: savedPosition, duration: 0.3)
            let scaleDown = SKAction.scale(to: 1.0, duration: 0.3)
            run(SKAction.group([slide, scaleDown]), completion: {
                self.enlarged = false
                self.zPosition = CardLevel.board.rawValue
            })
        } else {
            enlarged = true
            savedPosition = position

            zPosition = CardLevel.enlarged.rawValue

            if let parent = parent {
                removeAllActions()
                zRotation = 0
                let newPosition = CGPoint(x: parent.frame.midX, y: parent.frame.midY)
                let slide = SKAction.move(to: newPosition, duration: 0.3)
                let scaleUp = SKAction.scale(to: 5.0, duration: 0.3)
                run(SKAction.group([slide, scaleUp]))
            }
        }
    }

    func selectCard() {
        print("Selected")
    }
}
