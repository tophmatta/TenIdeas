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
        
        pushNextViewOntoStack()
        // Checks to see if element in array at specified index
        // If content view text doesn't equal array element text, update the array element text with new
        if ideaIsAtIndex() && currentIdeaList.allIdeas[currentIdea.index].text != contentTextView.text {
            currentIdeaList.allIdeas[currentIdea.index].text = contentTextView.text
            print("text updated")
            
            return
        }
        
        // If no element exists
        print("idea appended")
        appendIdea()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        appendIdea()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func finishButtonPressed(_ sender: Any) {
        appendIdea()
        encodeListAndSaveToDefaults()
        // dimiss modal
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateIndexAndRespectiveUI()
        let check = ideaIsAtIndex()
        if check {
            contentTextView.text = currentIdeaList.allIdeas[currentIdea.index].text
        }
        //print("Idea exists at\(currentIdea.index): \(check)")
        performMiscUIActions()
        formatContentTextViewParameters()
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
    
    // Persisting already created ideas when navigation through flow
    // Check array and if already created, grab idea at currentIdea.index
    func ideaIsAtIndex() -> Bool {
        let index = currentIdea.index
        if currentIdeaList.allIdeas.isEmpty || !currentIdeaList.allIdeas.indices.contains(index) {
            print("allIdeas or idea is empty")
            return false
        }
        print("there have already been ideas")
        contentTextView.text = currentIdeaList.allIdeas[index].text
        print("\(contentTextView.text)")
        return true
    }
    
    // Update index on current view & prepare indices on proximity views
    func updateIndexAndRespectiveUI(){
        switch currentIdea.index {
        case 0:
            currentIdea.index = 1
            currentIdea.nextIndex = currentIdea.index + 1
            
            // Hide back & finish button
            backButtonLabel.isHidden = true
            //finishButtonLabel.isHidden = true
        case 1:
            currentIdea.index += 1
            currentIdea.nextIndex = currentIdea.index + 1
            currentIdea.previousIndex = nil
            
            // Show back button, hide finish
            backButtonLabel.isHidden = false
            //finishButtonLabel.isHidden = true
        case 2...8:
            currentIdea.index += 1
            currentIdea.nextIndex = currentIdea.index + 1
            currentIdea.previousIndex = currentIdea.index - 1
            
            // Hide finish button
            //finishButtonLabel.isHidden = true
        case 9:
            currentIdea.index += 1
            currentIdea.nextIndex = nil
            currentIdea.previousIndex = currentIdea.index - 1
            
            // Show finish button and hide next button
            //finishButtonLabel.isHidden = false
            nextButtonLabel.isHidden = true
        default:
            break
        }
    }
    
    func pushNextViewOntoStack(){
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "lvc") as! ListCreationViewController
        destination.currentIdeaList = currentIdeaList
        
        // See if next view already has idea object at index
        // If so, grab future idea at index and load text into content view
        if currentIdeaList.allIdeas.indices.contains(currentIdea.index + 1) {
            destination.currentIdea = currentIdeaList.allIdeas[currentIdea.index+1]
        } else {
            // Used struct instead of class for 'Idea' to create a copy instead of reference to be able to use below logic
            destination.currentIdea = currentIdea
        }
        
        
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
    
    // Implements placeholder disappearing funcionality when begin to type
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

