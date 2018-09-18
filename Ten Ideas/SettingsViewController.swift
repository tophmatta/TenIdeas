//
//  SettingsViewController.swift
//  Ten Ideas
//
//  Created by Toph on 9/13/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {
    
    @IBOutlet var doneButtonLabel: UIButton!
    @IBOutlet var deleteAllListsButtonLabel: UIButton!
    
    @IBAction func deleteAllListsButtonPressed(_ sender: Any) {
        
        let alert = UIAlertController.init(title: "Delete All Lists", message: "Are you 100% sure?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (alert) in
            
            IdeaStore.deleteAllRealmObjects()
            
            let nestedAlert = UIAlertController(title: "Completed", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            nestedAlert.addAction(okAction)
            self.present(nestedAlert, animated: true, completion: nil)
        }
        let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        // Add radial border around buttons
        doneButtonLabel.layer.borderColor = UIColor.black.cgColor
        doneButtonLabel.layer.borderWidth = 1
        doneButtonLabel.layer.cornerRadius = 7
        deleteAllListsButtonLabel.layer.borderColor = UIColor.black.cgColor
        deleteAllListsButtonLabel.layer.borderWidth = 1
        deleteAllListsButtonLabel.layer.cornerRadius = 10
        
    }
    
}
