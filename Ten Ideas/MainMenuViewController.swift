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
    
    var retrievedArray: [Idea]?
    var retrievedArrayName: String?
        
    @IBAction func startListSequence(_ sender: Any) {
        pullUpNavController()
    }
    
    func getObject(){
        let realm = try! Realm()
        guard let value = realm.object(ofType: IdeaStore.self, forPrimaryKey: "List 109") else {
            print("didn't work")
            return
        }
        print(value.allIdeas[0].text)
    }
    
    @IBAction func checkUserDefaults(_ sender: Any) {
        getObject()
//        let defaults = UserDefaults.standard
//        if let array = defaults.value(forKey: "List 109") as? [Idea] {
//            for i in 0..<array.count{
//                print(array[i].text)
//            }
//        }
//        if let data = defaults.value(forKey: "List 109") as? Data {
//            retrievedArray = try? PropertyListDecoder().decode(Array<Idea>.self, from: data)
//            if let idea = retrievedArray {
//                for i in 0..<idea.count {
//                    print(idea[i].text)
//                }
//            }
//        }
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
