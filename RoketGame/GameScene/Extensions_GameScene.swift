//
//  Extensions_GameScene.swift
//  RoketGame
//
//  Created by Misha Dovhiy on 05.08.2023.
//

import SpriteKit
import GameplayKit

extension GameScene {
    func setLvl() {
        createBackground()
        createBorders()
        createBlockers()
    }
    
    func setDeviceMotion() {
        if motionManager.isDeviceMotionAvailable {
                
            motionManager.deviceMotionUpdateInterval = 0.1
            let queue = OperationQueue()
            motionManager.startDeviceMotionUpdates(to: queue, withHandler: { [weak self] motion, error in
                    
                if let attitude = motion?.attitude {
                    let result = attitude.pitch * 180.0/Double.pi

                    DispatchQueue.main.async {
                        self?.deviceMotionChanged(new: result)
                    }
                }
                    
            })
                
            print("Device motion started")
        }else {
            print("Device motion unavailable")
        }
    }
    
    var superHeight:CGFloat {
        return frame.height + (frame.height / 2)
    }
    
    private func createBackground() {
        let backHeight:CGFloat = 935.132
        let count = superHeight / backHeight
        var fromY = frame.height / -2
        for _ in 0..<Int(count + 1) {
            let sprite = SKSpriteNode.init(texture: .init(imageNamed: "stars"))
            sprite.position = .init(x: 0, y: fromY)
            fromY += backHeight
            sprite.size = .init(width: frame.width, height: backHeight)
            sprite.zPosition = -1
            insertChild(sprite, at: 0)
        }
    }
    
    private func createBorders() {
        for i in 0..<2 {
            let sprite = SKSpriteNode.init(color: .green, size: .init(width: 50, height: superHeight))
            let w = frame.width / 2
            sprite.position = .init(x: i == 0 ? (w * -1) : (frame.width - w), y: frame.height / -2)
            sprite.anchorPoint = .init(x: 0, y: 0)
            
            let phBody = SKPhysicsBody(rectangleOf: .init(width: 50, height: superHeight))
            phBody.categoryBitMask = 8
            phBody.collisionBitMask = 2
            phBody.fieldBitMask = 0
            phBody.contactTestBitMask = 2
            phBody.affectedByGravity = false
            phBody.allowsRotation = false
            phBody.isDynamic = false
            sprite.physicsBody = phBody
            
            addChild(sprite)
        }
    }

    
    private func createBlockers() {
        let width:CGFloat = 500
        let count = 40
        for i in 0..<count {
            let sprite = SKSpriteNode.init(color: .green, size: .init(width: width, height: 70))
            let xR = ((frame.width / 2) * -1)...(frame.width - (frame.width / 2))
            let distance = Int(frame.height) / count
            let y = i * distance
            let yR = CGFloat(y)...CGFloat((y + 1) * 2)
            sprite.position = .init(x: .random(in: xR), y: .random(in: yR))

            
            sprite.anchorPoint = .init(x: 0.5, y: 0.5)
            sprite.color = .green
            let phBody = SKPhysicsBody(rectangleOf: .init(width: width, height:70))
            phBody.categoryBitMask = 8
            phBody.collisionBitMask = 2
            phBody.fieldBitMask = 0
            phBody.contactTestBitMask = 2
            phBody.affectedByGravity = false
            phBody.allowsRotation = false
            phBody.isDynamic = false
            sprite.physicsBody = phBody
            addChild(sprite)
            
            let label = SKLabelNode(text: "\(i)")
            label.fontSize = 30
            label.fontColor = .red
            sprite.addChild(label)
        }
    }
    
}

