//
//  ListCreationViewController.swift
//  Ten Ideas
//
//  Created by Toph on 7/9/18.
//  Copyright © 2018 Toph. All rights reserved.
//
import UIKit
import RealmSwift

class ListCreationViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var listNumberLabel: UILabel!
    @IBOutlet var ideaNumberLabel: UILabel!
    @IBOutlet var backButtonLabel: UIButton!
    @IBOutlet var nextButtonLabel: UIButton!
    @IBOutlet var finishButtonLabel: UIButton!
    @IBOutlet var contentTextView: UITextView!
    
    var placeholderLabel: UILabel!
    var currentIdeaList: IdeaStore!
    var currentIdea: Idea!
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        // 1) Checks to see if index exists in ideaStore
        // 2) If contentTextView doesn't equal ideaStore object text, update object text in allIdeas array
        if ideaIsAtIndex() {
            if currentIdeaList.allIdeas[currentIdea.index-1].text != contentTextView.text, let contentTVtext = contentTextView.text {
                currentIdeaList.allIdeas[currentIdea.index-1].text = contentTVtext
            }
        } else {
            // If no element exists
            appendIdea()
        }
        pushNextViewOntoStack()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        // if content text view not same as currentIdea text or idea hasn't been saved, spawn alert view
        
        guard contentTextView.text.isEmpty else {
            let alert = UIAlertController.init(title: Constant.Alert.deleteTitle, message: Constant.Alert.deleteMessage, preferredStyle: .alert)
            let yesAction = UIAlertAction(title: Constant.Alert.yes, style: .default, handler: { (UIAlertAction) in
                if self.ideaIsAtIndex(), self.currentIdeaList.allIdeas[self.currentIdea.index-1].text != self.contentTextView.text, let contentTVtext = self.contentTextView.text {
                    self.currentIdeaList.allIdeas[self.currentIdea.index-1].text = contentTVtext
                } else {
                    self.appendIdea()
                }
                self.navigationController?.popViewController(animated: true)
            })
            let noAction = UIAlertAction(title: Constant.Alert.no, style: .default) { (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if !ideaIsAtIndex(){
            appendIdea()
        }
        // Ask if want to name list with alert viewcontroller
        let alert = UIAlertController.init(title: Constant.Alert.nameTitle, message: Constant.Alert.nameMessage, preferredStyle: .alert)
        let noAction = UIAlertAction(title: Constant.Alert.no, style: .default) { (action) in
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        }
        let yesUpdateAction = UIAlertAction(title: Constant.Alert.yesUpdate, style: .default, handler: { (UIAlertAction) in
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
        alert.addTextField { (textfield) in
            if let textfieldText = textfield.text, !textfield.text!.isEmpty {
                self.currentIdeaList.ideaListTitle = textfieldText
            }
        }
        alert.addAction(yesUpdateAction)
        alert.addAction(noAction)
        
        self.present(alert, animated: true, completion: nil)
        self.save(object: currentIdeaList, withTitle: currentIdeaList.ideaListTitle)
        //encodeListAndSaveToDefaults()
    }
    
    @IBAction func dismissKeyboard(sender: Any) {
        contentTextView.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        updateUI(for: currentIdea.index)
        formatContentTextViewParameters()
        if ideaIsAtIndex() {
            contentTextView.text = currentIdea.text
            placeholderLabel.isHidden = contentTextView.text.isEmpty ? false : true
        }
        performMiscUIActions()
    }
    
    // MARK:- IDEA HANDLERS/INITIALIZERS
    
    // Persisting already created ideas when navigation through flow
    // Check array and if already created, grab idea at currentIdea.index
    // *Note: allIdeas index is n-1 currentIdea.index
    func ideaIsAtIndex() -> Bool {
        let index = currentIdea.index
        if currentIdeaList.allIdeas.isEmpty || !currentIdeaList.allIdeas.indices.contains(index - 1) {
            return false
        }
        return true
    }
    
    // Take content text view text and append to [Idea]
    func appendIdea(){
        currentIdea.text  = contentTextView.text
        currentIdeaList.allIdeas.append(currentIdea)
    }
    
    func save(object: IdeaStore, withTitle title: String){
        
        object.ideaListTitle = title
        print(object)
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
    }
    
    // Encode [Idea] object and save to user defaults
    func encodeListAndSaveToDefaults(){
        let ideaListArray = currentIdeaList.allIdeas
        let ideaListTitle = currentIdeaList.ideaListTitle
        
        // Save list - UserDefaults
        IdeaStore.saveIdeasToDefaults(with: ideaListArray, key: ideaListTitle)
    }
    
    func pushNextViewOntoStack(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "lvc") as! ListCreationViewController
        // See if next view already has idea object at index
        // Note: allIdeas index is n-1 currentIdea.index
        if !currentIdeaList.allIdeas.indices.contains(currentIdea.index) {
            // Initialize a new idea
            destination.currentIdea = Idea()
            destination.currentIdea.index = currentIdea.index + 1
        } else {
            // If so, grab future idea text at index and load it into content text view
            destination.currentIdea = currentIdeaList.allIdeas[currentIdea.index]
        }
        destination.currentIdeaList = currentIdeaList
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK:- UI ELEMENTS METHODS
    
    //Update index on current view & prepare indices on proximity views
    func updateUI(for index:Int){
        switch index {
        case 1:
            backButtonLabel.isHidden = true
            finishButtonLabel.isHidden = true
        case 2...9:
            finishButtonLabel.isHidden = false
            backButtonLabel.isHidden = false
        case 10:
            nextButtonLabel.isHidden = true
        default:
            break
        }
    }
    
    // Miscellaneous UI actions
    func performMiscUIActions(){
        contentTextView.delegate = self
        self.navigationItem.title = ""
        listNumberLabel.text = currentIdeaList.ideaListTitle
        ideaNumberLabel.text = String(currentIdea.index)
        // Disable next button if no text
        if contentTextView.text.isEmpty {
            nextButtonLabel.isEnabled = false
        }
    }
    
    // Content text view functionality
    func formatContentTextViewParameters(){
        // Logic expands UITextview as words are entered
        let fixedWidth = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        contentTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        // Logic for setting up UITextView placeholder parameters
        placeholderLabel = UILabel()
        placeholderLabel.text = Constant.PlaceholderText.contentTextPlaceholder
        placeholderLabel.font = UIFont.systemFont(ofSize: (contentTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        contentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (contentTextView.font?.pointSize)!/2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !contentTextView.text.isEmpty
    }
    
    // MARK:- UITEXTVIEW DELEGATE METHODS
    
    // Implements placeholder disappearing functionality upon typing
    // Disables/Enables next button upon typing
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = contentTextView.text.isEmpty ? false : true
        nextButtonLabel.isEnabled = contentTextView.text.isEmpty ? false : true
    }
    
    // Setting character count - checks # of characters each time text is changed by replacing the same text w/ itself
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }

    // MARK:- CONSTANTS
    struct Constant {
        struct PlaceholderText {
            static let contentTextPlaceholder = "Start writing..."
        }
        struct Alert {
            static let deleteTitle = "Hold on one sec"
            static let deleteMessage = "Do you want to save your idea?"
            static let nameTitle = "Feel like naming your list?"
            static let nameMessage = "If so, cool. If not, cool."
            static let yesUpdate = "Yes, update"
            static let yes = "Yes"
            static let no = "No"
        }
    }
}



