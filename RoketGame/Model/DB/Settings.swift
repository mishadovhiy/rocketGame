//
//  Settings.swift
//  ElonGame
//
//  Created by Misha Dovhiy on 01.07.2023.
//

import Foundation

extension DB {
    struct Settings {
        var dict:[String:Any]
        init(dict: [String : Any]) {
            self.dict = dict
        }
        
        var game:Game {
            get {
                return .init(dict: dict["gamee"] as? [String:Any] ?? [:])
            }
            set {
                dict.updateValue(newValue.dict, forKey: "gamee")
            }
        }
        
        struct Game {
            var dict:[String:Any]
            init(dict: [String : Any]) {
                self.dict = dict
            }
            
            var fastRocket:Bool {
                get {
                    return dict["fastRocket"] as? Bool ?? false
                }
                set {
                    dict.updateValue(newValue, forKey: "fastRocket")
                }
            }
            
            
        }
    }
}
