//
//  IdeasViewController.swift
//  Ten Ideas
//
//  Created by Toph on 5/31/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class IdeasViewController: UITableViewController {
    
    // Delegate and Datas source set in storyboard
    @IBOutlet var tableview: UITableView!
    
    var tableviewData = IdeaStore.fetchAllListsWithTitle()
    var listFetchArray = [ListFetch]()
    var objectTitleToPass:String!
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    struct ListFetch {
        var title: String
        var content: List<Idea>
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        for (key,value) in tableviewData {
            listFetchArray.append(ListFetch(title: key, content: value))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableviewData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Create an instance of UITableViewCell, with default appearance
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // Set the text on the cell with the description of the idea
            
        cell.textLabel?.text = listFetchArray[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get cell label
        let indexPath = tableview.indexPathForSelectedRow
        let currentCell = tableview.cellForRow(at: indexPath!) as UITableViewCell?
        
        if let cellText = currentCell?.textLabel?.text {
            objectTitleToPass = cellText
        }
        //pushDetailViewOntoStack()
        performSegue(withIdentifier: "itemized", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "itemized" {
            let vc = segue.destination as! ItemizedIdeaViewController
            vc.passedReviewIdeaStore = IdeaStore.fetchIdeaStoreForDetailView(with: objectTitleToPass)
        }
    }
    
//    func pushDetailViewOntoStack(){
//        let destination = self.storyboard?.instantiateViewController(withIdentifier: "itemized") as! ItemizedIdeaTableViewController
//        destination.passedReviewIdeaStore = IdeaStore.fetchIdeaStoreForDetailView(with: objectTitleToPass)
//        navigationController?.pushViewController(destination, animated: true)
//    }
    
}
