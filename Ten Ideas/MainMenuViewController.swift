//
//  MainMenuViewController.swift
//  Ten Ideas
//
//  Created by Toph on 6/6/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

class MainMenuViewController: UIViewController {
    
    @IBAction func startListSequence(_ sender: Any) {
        pullUpNavController(withIdentifier: "lvc")
    }
    
    @IBAction func showAllListsButtonPressed(_ sender: Any) {
        pullUpNavController(withIdentifier: "ivc")
    }
    
    @IBAction func deleteRealmObjects(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    @IBAction func fetchDataButtonPressed(_ sender: Any) {
        
        print(IdeaStore.fetchAllListsWithTitle())
    }
    
    func pullUpNavController(withIdentifier identifier: String){
        if identifier == "lvc"{
            let destination = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! ListCreationViewController
            let navVC = UINavigationController(rootViewController: destination) as UIViewController
            navVC.navigationItem.title = ""
            self.show(navVC, sender: self)
        } else if identifier == "ivc"{
            //let destination = self.storyboard?.instantiateViewController(withIdentifier: identifier) as! IdeasViewController
            //let navVC = UINavigationController(rootViewController: destination) as UIViewController
            //self.show(navVC, sender: self)
        }
    }
}
