//
//  update_GameScene.swift
//  RoketGame
//
//  Created by Misha Dovhiy on 05.08.2023.
//

import SpriteKit
import GameplayKit

extension GameScene {
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        if isOver {
            return
        }
        if (rocket?.position.y ?? 0) < self.frame.height {
            self.moveCamera()
        } else {
            self.lvlOver()
        }
    }
    
    private func moveCamera() {
        cameraNode?.position = rocket?.position ?? .zero
        GameViewController.shared?.sceneCameraMoved(new: cameraNode?.position ?? .zero)
    }


}
