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
    
    // Convenience init necessary per Realm requirements
    convenience init(ideaListTitle: String) {
        self.init()
        self.ideaListTitle = ideaListTitle
    }
    
    static func fetchLastListNumber() -> Int? {
        let realm = try! Realm()
        let ideaStores = realm.objects(IdeaStore.self)
        let ideaListNumbers = Array(ideaStores.map{$0.ideaListNumber}) //sorted{$0.value! < $1.value!}
        var nonNilNumberArray = [Int]()
        for i in 0..<ideaListNumbers.count {
            if let nonNilValue = ideaListNumbers[i].value {
                nonNilNumberArray.append(nonNilValue)
            }
        }
        let lastListNumber = nonNilNumberArray.sorted{$0 < $1}.last
        return lastListNumber
    }
    
    static func add(object: IdeaStore){
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    // Prepares data for table view of lists themselves
    static func fetchAllListsWithTitle() -> [String : List<Idea>] {
        let realm = try! Realm()
        // array of just ideas
        let lists = Array(realm.objects(IdeaStore.self).map{$0.allIdeas})
        // array of just the titles
        let titles = Array(realm.objects(IdeaStore.self).map{$0.ideaListTitle})
        
        var dict = [String : List<Idea>]()
        
        // maps title to respective list
        for i in 0..<lists.count {
            let title = titles[i]
            let list = lists[i]
            dict[title] = list
        }
        return dict
    }
    
    // Prepares data for itemized table view
    static func fetchIdeaStore(with title: String) -> IdeaStore {
        let realm = try! Realm()
        let ideaStore = realm.objects(IdeaStore.self).filter("ideaListTitle == %@", title)[0]
        return ideaStore
    }
    
    // Consolidates all bookmarked ideas for segmented control 'All Favorited'
    static func fetchAllBookmarkedIdeas() -> [Idea]{
        let realm = try! Realm()
        let arrayOfIdeas = Array(realm.objects(Idea.self).filter("bookmark == true"))
        return arrayOfIdeas
    }
    
    static func deleteAllRealmObjects(){
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    static func deleteIdeaStoreObject(withTitle listNameToDelete: String) {
        let realm = try! Realm()
        
        guard let ideaStoreToDelete = realm.objects(IdeaStore.self).filter("ideaListTitle == %@", listNameToDelete).first else { return }
        
        try! realm.write {
            // Delete all ideas associated to IdeaStore (was originally only deleting IdeaStore
            // and the assoc. Ideas would still be available, therefore had to delete them separately)
            for item in ideaStoreToDelete.allIdeas {
                realm.delete(realm.objects(Idea.self).filter("text == %@",item.text).first!)
            }
            // Delete IdeaStore itelf
            realm.delete(ideaStoreToDelete)
        }
    }
    
    static func updateIdeaListTitle(_ ideaListTitle: String, newText: String) {
        let realm = try! Realm()
        let ideaStore = IdeaStore.fetchIdeaStore(with: ideaListTitle)
        
        try! realm.write {
            ideaStore.ideaListTitle = newText
        }

    }
    
    static func hasReachedTenCount() -> Bool {
        let realm = try! Realm()
        let ideaStoreCount = realm.objects(IdeaStore.self).count
        return ideaStoreCount >= 10
    }
    
    static func fetchRandomRealmIdeaStoreList() -> IdeaStore {
        let realm = try! Realm()
        let listOfIdeaTitles = Array(realm.objects(IdeaStore.self).map({$0.ideaListTitle}))
        let randomNumber = Int(arc4random_uniform(UInt32(listOfIdeaTitles.count)))
        let randomIdeaStoreTitle = listOfIdeaTitles[randomNumber]
        let randomIdeaStoreObject = realm.objects(IdeaStore.self).filter("ideaListTitle == %@", randomIdeaStoreTitle)[0]
        return randomIdeaStoreObject
    }
    
    // Convert from realm object to all strings
    static func formatListsForExport(_ lists: [String : List<Idea>]) -> String {
        // Prepend with header for CSV
        var result = ["List Name", "List Item", "Favorited?"]
        
        lists.forEach { (list) in
            let listTitle = list.key
            let listItems = list.value

            listItems.forEach { (item) in
                let itemFormatted = item.formatForExportWith(listTitle)
                result.append(contentsOf: itemFormatted)
            }
        }
        let conResult = concatenateListStrings(result)
        //TODO: - got the strings in the format i want. need to figure out row breaks so it shows up properly in excel
        return conResult
    }
    
    static func concatenateListStrings(_ listStrings: [String]) -> String {
        return listStrings.map{$0 + ", "}.reduce("", +)
    }
        
    static func convertExportDictToCsvFormat() {
        let allListsRealmFormat = fetchAllListsWithTitle()
        let allListsStringFormat = formatListsForExport(allListsRealmFormat)
        print(allListsStringFormat)
    }
}

