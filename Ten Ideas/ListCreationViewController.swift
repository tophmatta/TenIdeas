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
    
    @IBOutlet var listTitleLabel: UILabel!
    @IBOutlet var ideaNumberLabel: UILabel!
    @IBOutlet var backButtonLabel: UIButton!
    @IBOutlet var nextButtonLabel: UIButton!
    @IBOutlet var finishButtonLabel: UIButton!
    @IBOutlet var contentTextView: UITextView!
    
    var placeholderLabel: UILabel!
    var currentIdeaList: IdeaStore!
    var currentIdea: Idea!
    
    // Initialize haptic feeback generator
    let impact = UIImpactFeedbackGenerator(style: UIImpactFeedbackStyle.medium)
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        // Haptic feedback action
        impact.impactOccurred()
        
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
        
        // Haptic feedback action
        impact.impactOccurred()
        
        guard contentTextView.text.isEmpty else {
            // if content text view not same as currentIdea text or idea hasn't been saved, spawn alert view
            if self.ideaIsAtIndex(), self.currentIdeaList.allIdeas[self.currentIdea.index-1].text != self.contentTextView.text, let contentTVtext = self.contentTextView.text {
                // idea is at index but has been changed
                let alert = UIAlertController.init(title: Constant.Alert.deleteTitle, message: Constant.Alert.deleteMessage, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: Constant.Alert.yes, style: .default, handler: { (UIAlertAction) in
                    self.currentIdeaList.allIdeas[self.currentIdea.index-1].text = contentTVtext
                    self.navigationController?.popViewController(animated: true)
                })
                let noAction = UIAlertAction(title: Constant.Alert.no, style: .default) { (UIAlertAction) in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
                return
            } else if !ideaIsAtIndex(){
                // idea is not a current index
                let alert = UIAlertController.init(title: Constant.Alert.deleteTitle, message: Constant.Alert.deleteMessage, preferredStyle: .alert)
                let yesAction = UIAlertAction(title: Constant.Alert.yes, style: .default, handler: { (UIAlertAction) in
                    self.appendIdea()
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
            // called when idea exists in store and is unchanged
            navigationController?.popViewController(animated: true)
            return
        }
        // called when text empty
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        guard contentTextView.text.isEmpty else {
            let alert = UIAlertController.init(title: Constant.Alert.cancelTitle, message: Constant.Alert.cancelMessage, preferredStyle: .alert)
            let noAction = UIAlertAction(title: Constant.Alert.no, style: .default) { (action) in
                self.presentedViewController?.dismiss(animated: false, completion: nil)
            }
            let yesAction = UIAlertAction(title: Constant.Alert.yes, style: .default, handler: { (UIAlertAction) in
                self.presentedViewController?.dismiss(animated: false, completion: nil)
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(yesAction)
            alert.addAction(noAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if !ideaIsAtIndex() && !contentTextView.text.isEmpty {
            appendIdea()
        }
        // Ask if want to name list with alert viewcontroller
        let alert = UIAlertController.init(title: Constant.Alert.nameTitle, message: Constant.Alert.nameMessage, preferredStyle: .alert)
        let noAction = UIAlertAction(title: Constant.Alert.no, style: .default) { (action) in
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: {
                // Update idea list title property with title label text
                self.currentIdeaList.ideaListTitle = self.listTitleLabel.text ?? "error"
                // Save to realm db
                IdeaStore.save(object: self.currentIdeaList)
            })
        }
        let yesUpdateAction = UIAlertAction(title: Constant.Alert.yesUpdate, style: .default, handler: { (UIAlertAction) in
            self.presentedViewController?.dismiss(animated: false, completion: nil)
            self.dismiss(animated: true, completion: {
                if let textfieldText = alert.textFields?.first?.text, !textfieldText.isEmpty {
                    // Value for user defined name
                    self.currentIdeaList.ideaListTitle = textfieldText
                    self.currentIdeaList.ideaListNumber.value = nil
                }
                // Save to realm db
                IdeaStore.save(object: self.currentIdeaList)
            })
        })
        alert.addTextField(configurationHandler: nil)
        alert.addAction(yesUpdateAction)
        alert.addAction(noAction)
        self.present(alert, animated: true)
    }
    
    @IBAction func dismissKeyboard(sender: Any) {
        contentTextView.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if IdeaStore needs to be instantiated
        if navigationController?.viewControllers.count == 1 {
            checkForIdeaStore()
        } else {
            listTitleLabel.text = currentIdeaList.ideaListTitle
        }
        updateUI(for: currentIdea.index)
        formatContentTextViewParameters()
        if ideaIsAtIndex() {
            contentTextView.text = currentIdea.text
            placeholderLabel.isHidden = contentTextView.text.isEmpty ? false : true
        }
        performMiscellaneousUIActions()
    }
    
    // MARK:- IDEA HANDLERS/INITIALIZERS
    
    // Check if first VC on Nav stack and handle IdeaStore appropriately
    func checkForIdeaStore(){
        // Create instances for
        currentIdeaList = IdeaStore()
        currentIdea = Idea()
        if let fetchedListNumber = IdeaStore.fetchLastListNumber() {
            // Update object property and add 1 to last number
            currentIdeaList.ideaListNumber.value = fetchedListNumber + 1
            // Update UI
            listTitleLabel.text = "list \(currentIdeaList.ideaListNumber.value ?? 0)"
            currentIdeaList.ideaListTitle = listTitleLabel.text ?? "#"
        } else {
            // For default list number 1
            currentIdeaList.ideaListNumber.value = 1
            listTitleLabel.text = "list \(currentIdeaList.ideaListNumber.value!)"
            currentIdeaList.ideaListTitle = listTitleLabel.text!
        }
    }
    
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
        destination.currentIdeaList.ideaListTitle = currentIdeaList.ideaListTitle
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK:- UI ELEMENTS METHODS
    
    // Update index on current view & prepare indices on proximity views
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
    func performMiscellaneousUIActions(){
        contentTextView.delegate = self
        self.navigationItem.title = ""
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
        //placeholderLabel.font = UIFont.systemFont(ofSize: (contentTextView.font?.pointSize)!)
        placeholderLabel.font = UIFont.systemFont(ofSize: (contentTextView.font?.pointSize)!, weight: .thin)
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
        // If text is not equal to line break/return
        if text != "\n" {
            return numberOfChars < 175
        }
        // text = to return; dismiss keyboard
        contentTextView.resignFirstResponder()
        return false
    }

    // MARK:- CONSTANTS
    struct Constant {
        struct PlaceholderText {
            static let contentTextPlaceholder = "Start writing..."
        }
        struct Alert {
            static let deleteTitle = "Hold on one sec"
            static let deleteMessage = "Do you want to save your idea?"
            static let cancelTitle = "Cancel list?"
            static let cancelMessage = "All list items will be deleted."
            static let nameTitle = "Feel like naming your list?"
            static let nameMessage = "If so, cool. If not, cool."
            static let yesUpdate = "Yes, Update"
            static let yes = "Yes"
            static let no = "No"
        }
    }
}



