//
//  IdeasViewController.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

class IdeasViewController: UITableViewController {
    
    var ideaStore: IdeaStore!
    
    let allLists = IdeaStore.fetchAllListsWithTitle()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        
    }
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return allLists.count
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Set the text on the cell with the description of the idea
        let idea = ideaStore.allIdeas[indexPath.row]
        
        //cell.textLabel?.text = idea.text
        
        return cell
    }
}
