//
//  IdeaStore.swift
//  Ten Ideas
//
//  Created by Toph on 6/4/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

class IdeaStore {
    var allIdeas = [[Idea]]()
    var ideaListTitle: String
    
//    func createIdea() -> Idea {
//        let newIdea = Idea(text: "Testing", bookmark: false)
//
//        allIdeas.append(newIdea)
//
//        return newIdea
//    }
    
    init(ideaListTitle: String) {
        self.ideaListTitle = ideaListTitle
        
//        for _ in 0..<5 {
//            createIdea()
//        }
    }
}

