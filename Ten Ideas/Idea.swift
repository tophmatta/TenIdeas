//
//  Idea.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

struct Idea: Codable {
    var text: String
    var boomkark: Bool?
    var index: Int
    let dateCreated: Date
    
    init() {
        self.text = "test"
        self.boomkark = nil
        self.index = 0
        self.dateCreated = Date()
    }
}
