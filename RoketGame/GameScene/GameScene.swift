//
//  GameScene.swift
//  RoketGame
//
//  Created by Misha Dovhiy on 05.08.2023.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    var rocket : SKSpriteNode?
    var cameraNode : SKCameraNode?
    
    let motionManager = CMMotionManager()
    var isOver = false
    var lvl:Int { 0}
    override func sceneDidLoad() {
        super.sceneDidLoad()
        physicsWorld.contactDelegate = self
        rocket = childNode(withName: "rocket") as? SKSpriteNode
        cameraNode = childNode(withName: "cameraNode") as? SKCameraNode
        setDeviceMotion()
        setLvl()
        if let y = DB.holder?.gameScore.rocketPosition.y, y != 0 {
            rocket?.position.y = y
        }
        
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false, block: { _ in
            self.rocket?.run(.repeatForever(.moveBy(x: 0, y: (DB.holder?.settings.game.fastRocket ?? false) ? 300 : 55, duration: 0.1)))
        })
        
        
    }
    
    func resume() {
        isPaused = false
        self.rocket?.run(.repeatForever(.moveBy(x: 0, y: (DB.holder?.settings.game.fastRocket ?? false) ? 300 : 55, duration: 0.1)))
    }
    
    func deviceMotionChanged(new:Double) {
        print(new, " grvewedws")
        if !isPaused {
            rocket?.run(.move(by: .init(dx: new, dy: 0), duration: 0.1))
        }
        
    }
    
    func lvlOver() {
        isOver = true
        DispatchQueue(label: "db", qos: .userInitiated).async {
            DB.data.gameScore.rocketPosition = .zero
            DispatchQueue.main.async {
                GameViewController.shared?.loadLvl(lvl: self.lvl + 1)
            }
        }
        
    }
    
    func pause() {
        isPaused = true
        self.removeAllActions()
        children.forEach({
            $0.removeAllActions()
        })
    }
    
    override func removeFromParent() {
        super.removeFromParent()
        DispatchQueue(label: "db", qos: .userInitiated).async {
            DB.data.gameScore.currentLvl = self.lvl
            if !self.isOver {
                DB.data.gameScore.rocketPosition = self.rocket?.position ?? .zero
            }
        }
    }
}


