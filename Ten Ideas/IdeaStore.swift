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
    let ideaListNumber = RealmOptional<Int>()
    
    convenience init(ideaListTitle: String) {
        self.init()
        self.ideaListTitle = ideaListTitle
    }
    
    static func fetchLastListNumber() -> Int? {
        let realm = try! Realm()
        let ideaStores = realm.objects(IdeaStore.self)
        let ideaListNumbers = Array(ideaStores.map{$0.ideaListNumber})
        guard let lastListNumber = ideaListNumbers.last?.value else {
            return nil
        }
        return lastListNumber
    }
        
    static func save(object: IdeaStore){
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    // TODO: Do something with result
    static func getObject(withKey key: String){
        let realm = try! Realm()
        let obj = realm.objects(IdeaStore.self)
        //print(obj.allIdeas)
    }
    // Check realm db for last default list # used
    
    static func checkRealmForLastUsedDefaultListNumber(){
        let realm = try! Realm()
        //let filter = "List"
        let name = realm.objects(IdeaStore.self).filter("ideaListTitle == 'List'")
    }

}

