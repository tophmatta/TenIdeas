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
    
    // Delegate and DataSource set in storyboard
    @IBOutlet var tableview: UITableView!
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var tableviewDataIdeaStore = IdeaStore.fetchAllListsWithTitle()
    var tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas()
    var listFetchArray = [ListFetch]()
    var objectTitleToPass:String!
    
    
    @IBAction func segmentValueChanged(_ sender: Any) {
        // Re-fetches newly favorited/unfavorited ideas and refreshes
        tableviewDataBookmarkedIdeas = IdeaStore.fetchAllBookmarkedIdeas()
        tableview.reloadData()
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct ListFetch {
        var title: String
        var content: List<Idea>
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        tableview.separatorColor = UIColor.black
        
        for (key,value) in tableviewDataIdeaStore {
            listFetchArray.append(ListFetch(title: key, content: value))
        }
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
        default:
            break
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemized" {
            let vc = segue.destination as! ItemizedIdeaViewController
            vc.passedReviewIdeaStore = IdeaStore.fetchIdeaStoreForDetailView(with: objectTitleToPass)
        }
    }
}
