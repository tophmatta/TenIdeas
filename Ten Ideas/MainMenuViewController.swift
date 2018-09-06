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
    
    let impact = UIImpactFeedbackGenerator()
    var hasRunAnimation:Bool?
    
    // View outlets
    @IBOutlet var tenSqaureView: UIView!
    
    // Button outlets
    @IBOutlet var createNewButtonLabel: UIButton!
    @IBOutlet var randomButtonLabel: UIButton!
    @IBOutlet var viewButtonLabel: UIButton!
    
    // Constraint outlets
    @IBOutlet var yellowTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var blueTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var redTrailingConstraint: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        if hasRunAnimation == nil {
            let screenWidth = view.frame.width
            
            yellowTrailingConstraint.constant = screenWidth
            blueTrailingConstraint.constant = screenWidth
            redTrailingConstraint.constant = screenWidth
            
            createNewButtonLabel.alpha = 0
            randomButtonLabel.alpha = 0
            viewButtonLabel.alpha = 0
        }
        
    }
    
    @IBAction func createNewButtonPressed(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "lvc") as! ListCreationViewController
        let navVC = UINavigationController(rootViewController: destination) as UIViewController
        navVC.navigationItem.title = ""
        self.show(navVC, sender: self)
    }
    
    @IBAction func randomButtonPressed(_ sender: Any) {
        if !IdeaStore.hasReachedTenCount() {
            let alert = UIAlertController.init(title: "Almost There!", message: "To random review old lists, you must first create 10", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "random", sender: self)
        }
    }
    
    @IBAction func deleteRealmObjects(_ sender: Any) {
        IdeaStore.deleteAllRealmObjects()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tenSqaureView.backgroundColor = UIColor.clear
        tenSqaureView.layer.borderWidth = 2
        tenSqaureView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        if hasRunAnimation == nil {
            fadeIn(buttonLabel: createNewButtonLabel, withDelay: 0.25)
            fadeIn(buttonLabel: randomButtonLabel, withDelay: 0.5)
            fadeIn(buttonLabel: viewButtonLabel, withDelay: 0.75)
            
            updateOffScreenView(forConstraint: yellowTrailingConstraint, withDelay: 0)
            updateOffScreenView(forConstraint: blueTrailingConstraint, withDelay: 0.25)
            updateOffScreenView(forConstraint: redTrailingConstraint, withDelay: 0.5)
            
            hasRunAnimation = true
        }
    }
    
    func fadeIn(buttonLabel: UIButton, withDelay delay:Double){
        UIView.animate(withDuration: 2.0,
                       delay: delay,
                       options: [],
                       animations: {
                        
                        buttonLabel.alpha = 1
        },
                       completion: nil)
    }
    
    func updateOffScreenView(forConstraint constraint:NSLayoutConstraint, withDelay delay:Double){
        let screenWidth = view.frame.width
        constraint.constant -= screenWidth
        
        UIView.animate(withDuration: 1.5,
                       delay: delay,
                       options: [],
                       animations: {
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
}
