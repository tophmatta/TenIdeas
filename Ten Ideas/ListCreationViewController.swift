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
    @IBOutlet var contentTextView: UITextView!
    
    var placeholderLabel: UILabel!
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        
        print("next")
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        
        print("back")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTextView.delegate = self
        let fixedWidth = contentTextView.frame.size.width
        let newSize = contentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        contentTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        
        placeholderLabel = UILabel()
        placeholderLabel.text = "Start writing..."
        placeholderLabel.font = UIFont.italicSystemFont(ofSize: (contentTextView.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        contentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (contentTextView.font?.pointSize)!/2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !contentTextView.text.isEmpty
 

    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        placeholderLabel.isHidden = contentTextView.text.isEmpty ? false : true
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 300
    }
    
    
//    func textViewDidEndEditing(_ textView: UITextView) {
//        print("textViewDidEndEditing")
//    }
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        print("textViewDidBeginEditing")
//    }
    
    @IBAction func dismissKeyboard(sender: Any) {
        contentTextView.resignFirstResponder()
    }
}

