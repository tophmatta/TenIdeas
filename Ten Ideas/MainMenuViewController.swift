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
    
    var ideaStore: IdeaStore!
    var idea: Idea! = Idea()
    
    @IBAction func startListSequence(_ sender: Any) {
        pullUpNavController()
    }
        
    @IBAction func checkRealmObject(_ sender: Any) {
        IdeaStore.getObject(withKey: "List 109")
    }
    
    func pullUpNavController(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "lvc") as! ListCreationViewController
        let navVC = UINavigationController(rootViewController: destination) as UIViewController
        navVC.navigationItem.title = ""
        destination.currentIdeaList = ideaStore
        destination.currentIdea = idea
        self.show(navVC, sender: self)
    }
}
