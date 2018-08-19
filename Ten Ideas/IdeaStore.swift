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
    // For Realm
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
    }
    
    static func save(object: IdeaStore, withTitle title: String){
        object.ideaListTitle = title
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    // TODO: Do something with result
    static func getObject(withKey key: String){
        let realm = try! Realm()
        guard let obj = realm.object(ofType: IdeaStore.self, forPrimaryKey: key) else {
            print("didn't work")
            return
        }
        //print(obj.allIdeas)
    }
    // Check realm db for last default list # used
    
    static func checkRealmForLastUsedDefaultListNumber(){
        let realm = try! Realm()
        //let filter = "List"
        let name = realm.objects(IdeaStore.self).filter("ideaListTitle == 'List'")
        
        
    }

}

