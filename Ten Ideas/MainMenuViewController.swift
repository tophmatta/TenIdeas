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

    @IBAction func startListSequence(_ sender: Any) {
        
        let listVC = self.storyboard?.instantiateViewController(withIdentifier: "lvc")
        let navVC = UINavigationController(rootViewController: listVC!) as UIViewController
        self.present(navVC, animated: true, completion: nil)
    }
    
}
