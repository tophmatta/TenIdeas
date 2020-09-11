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
    
    public func formatForExportWith(_ parentListTitle: String) -> [String] {
        return [parentListTitle, text, "\(bookmark)"]
    }
    
    // Convenience init necessary per Realm requirements
    convenience init(text: String, bookmark: Bool, index: Int){
        self.init()
        self.text = text
        self.bookmark = bookmark
        self.index = index
    }
    
    static func updateIdeaText(_ currentText: inout String, newText: String) {
        let realm = try! Realm()
        try! realm.write {
            currentText = newText
            print(currentText)
        }
    }
}
