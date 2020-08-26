//
//  IAllIdeaListsViewController.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class AllIdeaListsViewController: UITableViewController {
    
    // Delegate and Datasource set in storyboard
    
    // Outlets
    @IBOutlet var tableview: UITableView!
    @IBOutlet var navBar: UINavigationItem!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    // Data buckets
    private var tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()
    private var tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas().sorted{ $0.text < $1.text }
    
    // Takes Realm dict. data and stores it as key/value pairs
    private var listFetchArray = [ListFetch]()
    
    // Passes title to detail view to load list data on ItemizedIdeaVC
    private var objectTitleToPass:String!
    
    // Default bar button items
    private var doneButton:UIBarButtonItem!
    
    // Object that bridges/prepares Realm dictionary data into
    // objects to be displayed by the tableview
    private struct ListFetch {
        var title: String
        var content: List<Idea>
    }
    
    //MARK: - ACTION METHODS
    @IBAction func segmentValueChanged(_ sender: Any) {
        // Re-fetches newly favorited/unfavorited ideas and refreshes
        tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas().sorted{ $0.text < $1.text }
        tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()
        tableview.reloadData()
    }
    
    // Done button action - default
    @objc func doneButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        tableview.separatorColor = UIColor.black
        
        self.refresh()
        self.configureBarButtonItems()
    }
    
    // Splits out Realm dictionary into objects
    private func prepareIdeaStoreTableviewData(){
        // Must recalculate each time view appears to refresh changes
        listFetchArray.removeAll()
        
        for (key,value) in tableviewDataIdeaStore {
            listFetchArray.append(ListFetch(title: key, content: value))
        }
        listFetchArray = listFetchArray.sorted{ $0.title < $1.title }
    }
    
    private func configureBarButtonItems(){
        // Configure default nav bar buttons
        doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(AllIdeaListsViewController.doneButtonPressed))
        self.navBar.rightBarButtonItem = doneButton
    }
    
    private func refresh() {
        self.tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()
        self.tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas()
        self.prepareIdeaStoreTableviewData()
    }
    
    //MARK: - TABLEVIEW DATASOURCE/DELEGATE METHODS
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // default rows
        var tableviewCount = tableviewDataIdeaStore.count
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableviewCount = tableviewDataIdeaStore.count
            return tableviewCount
        case 1:
            tableviewCount = tableviewDataBookmarkedIdeas.count
            return tableviewCount
        default:
            break
        }
        return tableviewCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        // Triggered when segm. ctrl. experiences action
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell.textLabel?.text = listFetchArray[indexPath.row].title
            cell.textLabel?.font = UIFont.systemFont(ofSize: 30, weight: .ultraLight)
            cell.selectionStyle = .default
        case 1:
            cell.textLabel?.text = tableviewDataBookmarkedIdeas[indexPath.row].text
            cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .ultraLight)
            cell.selectionStyle = .none
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
        default:
            break
        }
        // Allows for exapandable row hts.
        cell.textLabel?.numberOfLines = 0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex != 1 {
            // Get cell label
            let indexPath = tableview.indexPathForSelectedRow
            let currentCell = tableview.cellForRow(at: indexPath!) as UITableViewCell?
            if let cellText = currentCell?.textLabel?.text {
                objectTitleToPass = cellText
            }
            performSegue(withIdentifier: "itemized", sender: self)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return segmentedControl.selectedSegmentIndex == 0 ? UITableViewCellEditingStyle.delete : UITableViewCellEditingStyle.none
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if segmentedControl.selectedSegmentIndex == 0 {
            let currentCell = self.tableview.cellForRow(at: indexPath) as UITableViewCell?
            
            let editAction = UITableViewRowAction(style: .default, title: "Rename", handler: { (action, indexPath) in
                let currentCellText = currentCell!.textLabel!.text!
                let alert = UIAlertController(title: "", message: "Rename list", preferredStyle: .alert)
                    
                alert.addTextField { (textfield) in
                    textfield.text = currentCellText
                }
                alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { (updateAction) in
                    // abstract this realm name update to ideastore class
                    IdeaStore.updateIdeaListTitle(currentCellText, newText: alert.textFields!.first!.text!)
                    self.refresh()
                    tableView.reloadRows(at: [indexPath], with: .fade)
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: false)
        })
            editAction.backgroundColor = UIColor.darkGray
            
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
                IdeaStore.deleteIdeaStoreObject(withTitle: currentCell!.textLabel!.text!)
                self.refresh()
                tableView.deleteRows(at: [indexPath], with: .left)
            })

            return [deleteAction, editAction]
        }
        return nil
    }
    
    // Passes data prior to segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemized" {
            let vc = segue.destination as! ItemizedIdeaViewController
            vc.passedReviewIdeaStore = IdeaStore.fetchIdeaStore(with: objectTitleToPass)
        }
    }
}
