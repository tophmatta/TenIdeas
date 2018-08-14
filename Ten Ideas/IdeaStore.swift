//
//  IdeaStore.swift
//  Ten Ideas
//
//  Created by Toph on 6/4/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class IdeaStore: Object {
    let allIdeas = List<Idea>()
    @objc dynamic var ideaListTitle: String = ""

    
    convenience init(ideaListTitle: String) {
        self.init()
        self.ideaListTitle = ideaListTitle
    }
    
    override static func primaryKey() -> String {
        return "ideaListTitle"
    }
    static func saveIdeasToDefaults(with ideaArray:List<Idea>, key:String) {
        let realm = try! Realm()
        
        for i in ideaArray {
            print(i)
        }
        try! realm.write {
            realm.add(ideaArray)
        }
        
        // Save list - UserDefaults
        //let defaults = UserDefaults.standard
        //defaults.set(ideaArray, forKey: key)
        //defaults.setValue(try? PropertyListEncoder().encode(ideaArray), forKey: key)
    }
}

