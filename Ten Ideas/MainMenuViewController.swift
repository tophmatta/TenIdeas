//
//  MainMenuViewController.swift
//  Ten Ideas
//
//  Created by Toph on 6/6/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit
import RealmSwift

protocol MainMenuViewControllerDelegate: class {
    func didRunAnimation() -> Bool
}

extension MainMenuViewControllerDelegate {
    func didRunAnimation() {}
}

class MainMenuViewController: UIViewController, MainMenuViewControllerDelegate {
    
    let impact = UIImpactFeedbackGenerator()
    var hasRunAnimation:Bool?
    
    // View outlets
    @IBOutlet var tenSqaureView: UIView!
    
    // Button/Label outlets
    @IBOutlet var createNewButtonLabel: UIButton!
    @IBOutlet var randomButtonLabel: UIButton!
    @IBOutlet var viewButtonLabel: UIButton!
    @IBOutlet var settingsButtonLabel: UIButton!
    @IBOutlet var iLabel: UILabel!
    
    // Constraint outlets
    @IBOutlet var yellowTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var blueTrailingConstraint: NSLayoutConstraint!
    @IBOutlet var redTrailingConstraint: NSLayoutConstraint!
    
    weak var delegate: MainMenuViewControllerDelegate?
    
    //MARK: - IB ACTIONS
    @IBAction func createNewButtonPressed(_ sender: Any) {
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "lvc") as! ListCreationViewController
        let navVC = UINavigationController(rootViewController: destination) as UIViewController
        navVC.navigationItem.title = ""
        self.show(navVC, sender: self)
    }
    
    @IBAction func randomButtonPressed(_ sender: Any) {
        if !IdeaStore.hasReachedTenCount() {
            let alert = UIAlertController.init(title: "Almost There!", message: "To randomly review old lists, you must first create 10", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            let destination = self.storyboard?.instantiateViewController(withIdentifier: "random") as! RandomReviewViewController
            self.show(destination, sender: self)
        }
    }
    
    //MARK: - VC LIFECYCLE METHODS
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.delegate = self
        
        if hasRunAnimation == nil {
            let screenWidth = view.frame.width
            
            yellowTrailingConstraint.constant = screenWidth
            blueTrailingConstraint.constant = screenWidth
            redTrailingConstraint.constant = screenWidth
            
            createNewButtonLabel.alpha = 0
            randomButtonLabel.alpha = 0
            viewButtonLabel.alpha = 0
            settingsButtonLabel.alpha = 0
            tenSqaureView.alpha = 0
            iLabel.alpha = 0
            delegate?.didRunAnimation()
            
        }
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
            fadeIn(buttonLabel: createNewButtonLabel, withDelay: 1.25)
            fadeIn(buttonLabel: randomButtonLabel, withDelay: 1.5)
            fadeIn(buttonLabel: viewButtonLabel, withDelay: 1.75)
            fadeIn(buttonLabel: settingsButtonLabel, withDelay: 2.0)
            fadeIn(view: tenSqaureView, withDelay: 0)
            fadeIn(label: iLabel, withDelay: 0)
            
            updateOffScreenView(forConstraint: yellowTrailingConstraint, withDelay: 1)
            updateOffScreenView(forConstraint: blueTrailingConstraint, withDelay: 1.25)
            updateOffScreenView(forConstraint: redTrailingConstraint, withDelay: 1.5)
            
            hasRunAnimation = true
        }
    }
    
    func didRunAnimation() {
        print("didRunAnimation")
        hasRunAnimation = true
    }
    
    //MARK: - ANIMATIONS
    func fadeIn(buttonLabel: UIButton, withDelay delay: Double){
        UIView.animate(withDuration: 2.0,
                       delay: delay,
                       options: [],
                       animations: {
                        
                        buttonLabel.alpha = 1
        },
                       completion: nil)
    }
    
    func fadeIn(view: UIView, withDelay delay: Double){
        UIView.animateKeyframes(withDuration: 2.5,
                                delay: delay,
                                options: [],
                                animations: {
                                    
                                    view.alpha = 1
        },
                                completion: nil)
    }
    func fadeIn(label: UILabel, withDelay delay: Double){
        UIView.animateKeyframes(withDuration: 2.5,
                                delay: delay,
                                options: [],
                                animations: {
                                    
                                    label.alpha = 1
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
