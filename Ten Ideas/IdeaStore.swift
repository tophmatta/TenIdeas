//
//  IdeaStore.swift
//  Ten Ideas
//
//  Created by Toph on 6/4/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

class IdeaStore {
    var allIdeas = [Idea]()
    var ideaListTitle: String
    
    init(ideaListTitle: String) {
        self.ideaListTitle = ideaListTitle
    }
    
    static func saveIdeasToDefaults(with ideaArray:[Idea], key:String) {
        // Save list - UserDefaults
        let defaults = UserDefaults.standard
        defaults.setValue(try? PropertyListEncoder().encode(ideaArray), forKey: key)
    }
}

