//
//  TextFieldExtension.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 11.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    // Sets up a text field to look like the "classical" meme font
    func setMemeAttributes(withFont fontName: String, size: CGFloat, alignment: NSTextAlignment) {
        let textFieldAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: fontName, size: size)!,
            // The NSStrokeWidthAttributeName key's value has to be set to a negative value in order to show
            // both the stroke and the foreground color
            NSStrokeWidthAttributeName: -4.0
        ]
        self.defaultTextAttributes = textFieldAttributes
        self.textAlignment = alignment
    }
}
