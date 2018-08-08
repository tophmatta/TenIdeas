//
//  ListCreationViewController.swift
//  Ten Ideas
//
//  Created by Toph on 7/9/18.
//  Copyright © 2018 Toph. All rights reserved.
//

import UIKit

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
        //appendIdea()
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        if !ideaIsAtIndex(){
            appendIdea()
        }
        encodeListAndSaveToDefaults()
        // dimiss modal
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Index at
        if currentIdea.index == 0 {
            currentIdea.index = 1
        }
        
        performMiscUIActions()
        formatContentTextViewParameters()
        if ideaIsAtIndex() {
            print("current idea text: \(currentIdea.text)")
            contentTextView.text = currentIdea.text
            placeholderLabel.isHidden = contentTextView.text.isEmpty ? false : true
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
    
    // Encode [Idea] object and save to user defaults
    func encodeListAndSaveToDefaults(){
        let ideaListArray = currentIdeaList.allIdeas
        let ideaListTitle = currentIdeaList.ideaListTitle
        
        // Save list - UserDefaults
        let defaults = UserDefaults.standard
        defaults.setValue(try? PropertyListEncoder().encode(ideaListArray), forKey: ideaListTitle)
    }
    
    func pushNextViewOntoStack(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "lvc") as! ListCreationViewController
        // See if next view already has idea object at index
        // Note: allIdeas index is n-1 currentIdea.index
        if !currentIdeaList.allIdeas.indices.contains(currentIdea.index) {
            // Initialize a new idea
            destination.currentIdea = Idea()
            destination.currentIdea.index = currentIdea.index + 1
            //print("in there new idea")
        } else {
            // If so, grab future idea text at index and load it into content view
            destination.currentIdea = currentIdeaList.allIdeas[currentIdea.index]
            print("dest. idea txt: \(destination.currentIdea.text)")
            print("dest. idea idx: \(destination.currentIdea.index)")
            //print("in here already an idea")
        }
        destination.currentIdeaList = currentIdeaList
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: UI ELEMENTS
    
    // Miscellaneous UI actions
    func performMiscUIActions(){
        contentTextView.delegate = self
        self.navigationItem.title = ""
        listNumberLabel.text = currentIdeaList.ideaListTitle
        ideaNumberLabel.text = String(currentIdea.index)
    }
    
    // Content text view functionality
    func formatContentTextViewParameters(){
        // Logic expands UITextview as words are entered
        let fixedWidth = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        contentTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        // Logic for setting up UITextView placeholder parameters
        placeholderLabel = UILabel()
        placeholderLabel.text = "Start writing..."
        placeholderLabel.font = UIFont.systemFont(ofSize: (contentTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        contentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (contentTextView.font?.pointSize)!/2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !contentTextView.text.isEmpty
    }
    
    // Implements placeholder disappearing functionality when begin to type
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = contentTextView.text.isEmpty ? false : true
    }
    
    // Setting character count - checks # of characters each time text is changed by replacing the same text w/ itself
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300
    }
    
    // Keyboard actions
    @IBAction func dismissKeyboard(sender: Any) {
        contentTextView.resignFirstResponder()
    }
}



// Update index on current view & prepare indices on proximity views
//    func updateIndexAndRespectiveUI(){
//        switch currentIdea.index {
//        case 0:
//            currentIdea.index = 1
//            currentIdea.nextIndex = currentIdea.index + 1
//
//            // Hide back & finish button
//            backButtonLabel.isHidden = true
//            //finishButtonLabel.isHidden = true
//        case 1:
//            if !ideaIsAtIndex() {
//                currentIdea.index += 1
//            }
//            currentIdea.nextIndex = currentIdea.index + 1
//            currentIdea.previousIndex = currentIdea.index - 1
//
//            print("prev: \(currentIdea.previousIndex), current: \(currentIdea.index), next: \(currentIdea.nextIndex)")
//
//            // Show back button, hide finish
//            backButtonLabel.isHidden = false
//            //finishButtonLabel.isHidden = true
//        case 2...8:
//            if !ideaIsAtIndex() {
//                currentIdea.index += 1
//            }
//            currentIdea.nextIndex = currentIdea.index + 1
//            currentIdea.previousIndex = currentIdea.index - 1
//
//            print("prev: \(currentIdea.previousIndex), current: \(currentIdea.index), next: \(currentIdea.nextIndex)")
//
//            // Hide finish button
//            //finishButtonLabel.isHidden = true
//        case 9:
//            if !ideaIsAtIndex(){
//                currentIdea.index += 1
//                currentIdea.nextIndex = nil
//                currentIdea.previousIndex = currentIdea.index - 1
//
//            }
//
//            // Show finish button and hide next button
//            //finishButtonLabel.isHidden = false
//            nextButtonLabel.isHidden = true
//        default:
//            break
//        }
//    }

