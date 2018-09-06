//
//  Idea.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class Idea: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var bookmark: Bool = false
    @objc dynamic var index: Int = 1
    
    // Convenience init necessary per Realm requirements
    convenience init(text: String, bookmark: Bool, index: Int){
        self.init()
        self.text = text
        self.bookmark = bookmark
        self.index = index
    }
}
