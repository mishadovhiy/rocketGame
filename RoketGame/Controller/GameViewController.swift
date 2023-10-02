//
//  GameViewController.swift
//  RoketGame
//
//  Created by Misha Dovhiy on 05.08.2023.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    @IBOutlet weak var progressStack: UIStackView!
    
    static var shared:GameViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.shared = self

        reloadLvl()
    }
    
    func loadLvl(lvl:Int = 1) {
        print(lvl, " jbhgyuhjik")
        if let old = (self.view as! SKView?)?.scene {
            old.removeAllChildren()
            old.removeAllActions()
            old.removeFromParent()
        }
        if let scene = GKScene(fileNamed: "Lvl\(lvl)"),
           let sceneNode = scene.rootNode as? GameScene,
           let view = self.view as! SKView?
        {
            sceneNode.entities = scene.entities
            sceneNode.graphs = scene.graphs
            sceneNode.scaleMode = .aspectFill
            
            DispatchQueue(label: "db", qos: .userInitiated).async {
                DB.data.gameScore.currentLvl = lvl
                DispatchQueue.main.async {
                    view.presentScene(sceneNode)
                    view.ignoresSiblingOrder = true
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        } else {
            self.loadLvl()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        gameWillRemove()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func sceneCameraMoved(new position:CGPoint) {
        
        updateProgress(camera: position)
        
    }
    
    func gameWillRemove() {
        saveGame()
    }
    
    func pauseGame(resume:Bool = false) {
        if !resume {
            ((view as? SKView)?.scene as? GameScene)?.pause()
        } else {
            ((view as? SKView)?.scene as? GameScene)?.resume()
        }
    }
    
    func saveGame() {
        let scene = ((view as? SKView)?.scene as? GameScene)
        DispatchQueue(label: "db", qos: .userInitiated).async {
         //   DB.data.gameScore.currentLvl = scene?.lvl ?? 1
            DB.data.gameScore.rocketPosition = scene?.rocket?.position ?? .zero
        }
    }
    
    private func updateProgress(camera position:CGPoint) {
        let hei = ((view as? SKView)?.scene as? GameScene)?.frame.height ?? 0
        let height = hei + (hei / 2)

        let percent = (position.y + (hei / 2)) / height
        guard let progressView = progressStack.arrangedSubviews.first(where: {$0 as? UIProgressView != nil}) as? UIProgressView,
              let labelStack = progressStack.arrangedSubviews.first(where: {$0 as? UIStackView != nil}) as? UIStackView,
              let label = labelStack.arrangedSubviews.first(where: {$0 as? UILabel != nil}) as? UILabel
        else { return }
        progressView.progress = Float(percent)
        
        label.text = "\(Int(percent * 100)) % / Lvl: \(((self.view as? SKView)?.scene as? GameScene)?.lvl ?? 0)"
    }
    
    func reloadLvl(all:Bool = false, fromBeggining:Bool = false, isOver:Bool = false) {
        DispatchQueue(label: "db", qos: .userInitiated).async {
            let lv = DB.data.gameScore.currentLvl
            if fromBeggining {
                DB.data.gameScore.rocketPosition = .zero
                
            }
         //   let cur = ((view as? SKView)?.scene as? GameScene)?.lvl ?? 0
            DispatchQueue.main.async {
                if fromBeggining || isOver {
                    ((self.view as? SKView)?.scene as? GameScene)?.isOver = true
                }
                self.loadLvl(lvl: all ? 1 : lv)
            }
        }
        
    }
    

    
}
