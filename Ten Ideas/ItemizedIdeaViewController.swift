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
    
    // data from AllIdeasViewController
    var passedReviewIdeaStore: IdeaStore!
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = passedReviewIdeaStore.ideaListTitle
        tableview.separatorColor = UIColor.black
        
        let navAddButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ItemizedIdeaViewController.addListItem))
        self.navigationItem.setRightBarButton(navAddButton, animated: true)
    }
    
    // Ad hoc add idea to detail view list
    @objc private func addListItem() {
        let alert = UIAlertController(title: "", message: "Add list item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (updateAction) in
            let realm = try! Realm()
            let index = self.passedReviewIdeaStore.allIdeas.count + 1
            try! realm.write {
                let idea = Idea(text: alert.textFields!.first!.text!, bookmark: false, index: index)
                self.tableview.beginUpdates()
                self.passedReviewIdeaStore.allIdeas.append(idea)
                self.tableview.insertRows(at: [IndexPath(row: index - 1, section: 0)], with: .fade)
                self.tableview.endUpdates()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: false)
    }
    
    
    // MARK: - DELEGATE/DATASOURCE METHODS
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
                return
            }
            
            cell.accessoryType = .checkmark
            let realm = try! Realm()
            try! realm.write {
                passedReviewIdeaStore.allIdeas[indexPath.row].bookmark = true
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let alert = UIAlertController(title: "", message: "Edit list item", preferredStyle: .alert)
            alert.addTextField { (textfield) in
                textfield.text = self.passedReviewIdeaStore.allIdeas[indexPath.row].text
            }
            alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { (updateAction) in
                Idea.updateIdeaText(&self.passedReviewIdeaStore.allIdeas[indexPath.row].text, newText: alert.textFields!.first!.text!)
                self.tableview.reloadRows(at: [indexPath], with: .fade)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: false)
        })
        editAction.backgroundColor = UIColor.darkGray

        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let realm = try! Realm()
            try! realm.write {
                self.passedReviewIdeaStore.allIdeas.remove(at: indexPath.row)
            }
            self.tableview.reloadRows(at: [indexPath], with: .fade)
        })

        return [deleteAction, editAction]
    }
}
