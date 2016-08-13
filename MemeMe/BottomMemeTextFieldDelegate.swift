//
//  BottomMemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 12.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import Foundation
import UIKit

class BottomMemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        // This checks if the bottom text field's text property is "BOTTOM" which would mean that it's the default
        // value which should lead to the text field's text property being empty so the user can fill it with
        // own input
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // If the text field's text property is an empty string the value should be set back to the default value
        if textField.text == "" {
            textField.text = "BOTTOM"
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
