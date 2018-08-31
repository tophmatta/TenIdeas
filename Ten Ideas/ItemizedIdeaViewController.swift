//
//  ItemizedIdeaViewController.swift
//  Ten Ideas
//
//  Created by Toph on 8/25/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class ItemizedIdeaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var passedReviewIdeaStore:IdeaStore!
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = passedReviewIdeaStore.ideaListTitle
        tableview.separatorColor = UIColor.black
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passedReviewIdeaStore.allIdeas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = passedReviewIdeaStore.allIdeas[indexPath.row].text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .thin)
        tableView.rowHeight = UITableViewAutomaticDimension
        if passedReviewIdeaStore.allIdeas[indexPath.row].bookmark {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let cell = tableView.cellForRow(at: indexPath){
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                let realm = try! Realm()
                try! realm.write {
                    passedReviewIdeaStore.allIdeas[indexPath.row].bookmark = false
                }
            } else {
                cell.accessoryType = .checkmark
                let realm = try! Realm()
                try! realm.write {
                    passedReviewIdeaStore.allIdeas[indexPath.row].bookmark = true
                }
            }
        }
        
    }
    

}
