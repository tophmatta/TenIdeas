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
}

