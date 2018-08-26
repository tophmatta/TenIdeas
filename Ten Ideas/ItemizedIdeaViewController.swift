//
//  ItemizedIdeaTableViewController.swift
//  Ten Ideas
//
//  Created by Toph on 8/25/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class ItemizedIdeaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedReviewIdeaStore:IdeaStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = passedReviewIdeaStore.ideaListTitle
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedReviewIdeaStore.allIdeas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = passedReviewIdeaStore.allIdeas[indexPath.row].text

        return cell
    }


}
