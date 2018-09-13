//
//  RandomReviewViewController.swift
//  Ten Ideas
//
//  Created by Toph on 9/4/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class RandomReviewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var navigationBar: UINavigationBar!
    var tableviewData = IdeaStore.fetchRandomRealmIdeaStoreList()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationBar.backItem?.title = tableviewData.ideaListTitle
        tableview.separatorColor = UIColor.black
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        //TODO: IMPLEM. W/ ALERT VC
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        //TODO: IMPLEMENT UPDATE TO REALM BD WHEN DONE BTN PRESSED. ALSO ADD ALERT VC.
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewData.allIdeas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        cell.textLabel?.text = tableviewData.allIdeas[indexPath.row].text
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.systemFont(ofSize: 24, weight: .thin)
        tableView.rowHeight = UITableViewAutomaticDimension
        if tableviewData.allIdeas[indexPath.row].bookmark {
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
                    tableviewData.allIdeas[indexPath.row].bookmark = false
                }
            } else {
                cell.accessoryType = .checkmark
                let realm = try! Realm()
                try! realm.write {
                    tableviewData.allIdeas[indexPath.row].bookmark = true
                }
            }
        }
    }
}
