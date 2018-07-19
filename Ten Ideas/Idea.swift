//
//  Idea.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

class Idea: NSObject {
    var text: String
    var boomkark: Bool?
    var index: Int
    let dateCreated: Date
    
    override init() {
        self.text = ""
        self.boomkark = nil
        self.index = 0
        self.dateCreated = Date()
        
        super.init()
    }
    
//    convenience init(random: Bool = false) {
//        if random {
//
//            let firstNoun = ["Book", "Painting", "Beach", "Class"]
//            let adjective = ["wild", "dumb", "smart", "cool"]
//            let secondNoun = ["nudes", "babies", "hippies", "rednecks"]
//
//            var idx = arc4random_uniform(UInt32(firstNoun.count))
//            let randomFirstNoun = firstNoun[Int(idx)]
//
//            idx = arc4random_uniform(UInt32(adjective.count))
//            let randomAdjective = adjective[Int(idx)]
//
//            idx = arc4random_uniform(UInt32(secondNoun.count))
//            let randomSecondNoun = secondNoun[Int(idx)]
//
//            let randomPhrase = "\(randomFirstNoun) for \(randomAdjective) \(randomSecondNoun)"
//
//            let isNotBookmarked = false
//
//            self.init(text: randomPhrase, bookmark: isNotBookmarked)
//        }
//        else {
//            self.init(text: "", bookmark: nil)
//        }
//    }
}
