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
    var tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()
    var tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas().sorted{$0.text < $1.text}
    
    // Takes Realm dict. data and stores it as key/value pairs
    var listFetchArray = [ListFetch]()
    
    // Passes title to detail view to load list data on ItemizedIdeaVC
    var objectTitleToPass:String!
    
    // Default bar button items
    var editButton:UIBarButtonItem!
    var doneButton:UIBarButtonItem!
    
    // Object that prepares Realm dictionary data into
    // objects to bedisplayed by the tableview
    struct ListFetch {
        var title: String
        var content: List<Idea>
    }
    
    //MARK: - ACTION METHODS
    @IBAction func segmentValueChanged(_ sender: Any) {
        
        // Re-fetches newly favorited/unfavorited ideas and refreshes
        tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas().sorted{$0.text < $1.text}
        tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()

        tableview.reloadData()
        
        // 'Edit' button disappears when favorites/bookmark segment showing
        if segmentedControl.selectedSegmentIndex == 1 {
            self.navBar.leftBarButtonItem = nil
        } else {
            self.navBar.leftBarButtonItem = editButton
        }
    }
    
    @objc func editButtonPressed(){
        tableview.setEditing(true, animated: true)
        segmentedControl.isEnabled = false
        
        let doneEditingButton = UIBarButtonItem(barButtonSystemItem: .done,
                                                target: self,
                                                action: #selector(AllIdeaListsViewController.doneEditingButtonPressed))
        self.navBar.leftBarButtonItem = doneEditingButton
        self.navBar.rightBarButtonItem = nil
    }
    
    // Done button action - during editing
    @objc func doneEditingButtonPressed(){
        tableview.setEditing(false, animated: true)
        segmentedControl.isEnabled = true
        self.navBar.leftBarButtonItem = editButton
        self.navBar.rightBarButtonItem = doneButton
    }
    
    // Done button action - default
    @objc func doneButtonPressed(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            navBar.leftBarButtonItem?.title = "Done"
        } else {
            navBar.leftBarButtonItem?.title = "Edit"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        tableview.separatorColor = UIColor.black
        
        prepareIdeaStoreTableviewData()
        configureBarButtonItems()
    }
    
    // Splits out Realm dictionary into objects
    func prepareIdeaStoreTableviewData(){
        // Must recalculate each time view appears to refresh changes
        listFetchArray.removeAll()
        
        for (key,value) in tableviewDataIdeaStore {
            listFetchArray.append(ListFetch(title: key, content: value))
        }
        listFetchArray = listFetchArray.sorted{$0.title < $1.title}
    }
    
    // Initializes default bar button items
    func configureBarButtonItems(){
        // Configure default nav bar buttons
        editButton = UIBarButtonItem(barButtonSystemItem: .edit,
                                     target: self,
                                     action: #selector(AllIdeaListsViewController.editButtonPressed))
        doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                     target: self,
                                     action: #selector(AllIdeaListsViewController.doneButtonPressed))
        self.navBar.leftBarButtonItem = editButton
        self.navBar.rightBarButtonItem = doneButton
    }
    
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
    
    //MARK: - TABLEVIEW DATASOURCE/DELEGATE METHODS
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
    
    // Swipe left to delete list
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if segmentedControl.selectedSegmentIndex == 0 && editingStyle == .delete {
            let listTitle = listFetchArray[indexPath.row].title
            IdeaStore.deleteIdeaStoreObject(withTitle: listTitle)
            tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()
            tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas()
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    // Only allows swipe to delete on tableview of all lists
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if segmentedControl.selectedSegmentIndex == 1 {
            return UITableViewCellEditingStyle.none
        }
        return UITableViewCellEditingStyle.delete
    }
    
    // Passes data prior to segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemized" {
            let vc = segue.destination as! ItemizedIdeaViewController
            vc.passedReviewIdeaStore = IdeaStore.fetchIdeaStoreForDetailView(with: objectTitleToPass)
        }
    }
}
