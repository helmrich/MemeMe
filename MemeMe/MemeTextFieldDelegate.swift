//
//  MemeTextFieldDelegate.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 19.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldDidBeginEditing(textField: UITextField) {
        // This checks if the text field's property's value is...
        // - "TOP" and its tag is 0 which would mean that
        // the top text field did begin editing and that it currently has the default value 
        // - OR if the text property's value is "BOTTOM" and its tag is 1 which would mean that the bottom text
        // field did begin editing and currently has the default value
        
        // If either one of those statements evaluates to true the text field's text property should be set
        // to an empty string because the default value should be replaced
        if (textField.text == "TOP" && textField.tag == 0) || (textField.text == "BOTTOM" && textField.tag == 1) {
            textField.text = ""
        }
    }
        
    func textFieldDidEndEditing(textField: UITextField) {
        // If the text field's text property is an empty string the value should be set back to the default value
        // By also checking the text field's tag property it's ensured that the appropriate default value is set for
        // each text field
        if textField.text == "" && textField.tag == 0 {
            textField.text = "TOP"
        } else if textField.text == "" && textField.tag == 1 {
            textField.text = "BOTTOM"
        }
    }
        
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}