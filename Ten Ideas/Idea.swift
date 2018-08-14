//
//  Idea.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

class Idea: Object {
    @objc dynamic var text: String = ""
    @objc dynamic var bookmark: Bool = false
    @objc dynamic var index: Int = 1
    //@objc dynamic let dateCreated: Date = Date()
    
    required init(){
        super.init()
    }
    convenience required init(text: String, bookmark: Bool, index: Int){
        self.init()
        self.text = text
        self.bookmark = bookmark
        self.index = index
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
}
