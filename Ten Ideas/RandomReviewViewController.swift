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
    
    //MARK: - IB ACTION METHODS
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let alert = UIAlertController.init(title: "Are you sure?", message: "Changes will not be saved", preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .default) { (action) in
            self.presentedViewController?.dismiss(animated: false, completion: nil)
        }
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - VC LIFECYCLE METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationBar.items?.first?.title = "Reviewing: \(tableviewData.ideaListTitle)"
        tableview.separatorColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(false)
        
        // Cycle through visible tableview cells and update realm bookmark property
        for cell in tableview.visibleCells {
            if cell.accessoryType == .checkmark {
                let realm = try! Realm()
                if let indexOfBookmarkedCell = tableview.visibleCells.index(of: cell) {
                    try! realm.write {
                        tableviewData.allIdeas[indexOfBookmarkedCell].bookmark = true
                    }
                }
            }
        }
    }
    
    //MARK: - TABLEVIEW DATASOURCE/DELEGATE METHODS
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
