//
//  GameScore.swift
//  RoketGame
//
//  Created by Misha Dovhiy on 07.08.2023.
//

import Foundation

extension DB {
    struct GameScore {
        var dict:[String:Any]
        init(dict: [String : Any]) {
            self.dict = dict
        }
        
        var currentLvl:Int {
            get {
                return Int(dict["currentLvl"] as? String ?? "") ?? 1
            }
            set {
                dict.updateValue("\(newValue)", forKey: "currentLvl")
            }
        }
        
        var rocketPosition:CGPoint {
            get {
                let vals = dict["rocketPosition"] as? [String:Any] ?? [:]
                return .init(x: CGFloat(vals["x"] as? Double ?? 0), y: CGFloat(vals["y"] as? Double ?? 0))
            }
            set {
                dict.updateValue([
                    "x": Double(newValue.x),
                    "y": Double(newValue.y)
                ], forKey: "rocketPosition")
            }
        }
    }
}
