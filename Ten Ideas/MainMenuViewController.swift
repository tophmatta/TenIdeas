//
//  MainMenuViewController.swift
//  Ten Ideas
//
//  Created by Toph on 6/6/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    var ideaStore: IdeaStore!
    var idea: Idea! = Idea()
    
    var retrievedArray: [Idea]?
        
    @IBAction func startListSequence(_ sender: Any) {
        pullUpNavController()
    }
    
    @IBAction func checkUserDefaults(_ sender: Any) {
        let defaults = UserDefaults.standard
        if let data = defaults.value(forKey: "List 109") as? Data {
            retrievedArray = try? PropertyListDecoder().decode(Array<Idea>.self, from: data)
            if let idea = retrievedArray {
                for i in 0..<idea.count {
                    print(idea[i].text)
                }
            }
        }
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
