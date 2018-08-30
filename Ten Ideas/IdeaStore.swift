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
    
    // Grabs last non nil integer for new list seq
    static func fetchLastListNumber() -> Int? {
        let realm = try! Realm()
        let ideaStores = realm.objects(IdeaStore.self)
        let ideaListNumbers = Array(ideaStores.map{$0.ideaListNumber.value})
        let ideaListNumberCount = ideaListNumbers.filter({$0 != nil}).count
        return ideaListNumberCount
    }
    
    // Save object to realm
    static func save(object: IdeaStore){
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    // Prepares data for table view of lists themselves
    static func fetchAllListsWithTitle() -> [String:List<Idea>] {
        let realm = try! Realm()
        let listOfIdeaLists = Array(realm.objects(IdeaStore.self).map({$0.allIdeas}))
        let listOfIdeaTitles = Array(realm.objects(IdeaStore.self).map({$0.ideaListTitle}))
        
        var dict = [String:List<Idea>]()
        for i in 0..<listOfIdeaLists.count {
            let title = listOfIdeaTitles[i]
            let list = listOfIdeaLists[i]
            dict[title] = list
        }
        return dict
    }
    
    static func fetchIdeaStoreForDetailView(with title: String) -> IdeaStore {
        let realm = try! Realm()
        let ideaStore = realm.objects(IdeaStore.self).filter("ideaListTitle == %@", title)[0]
        return ideaStore
    }
    
}

