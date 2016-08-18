//
//  FontTableViewCell.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 16.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit

class FontTableViewCell: UITableViewCell {

    // Even though the text is static and won't changed/shouldn't be changed I'm using a text field here
    // so I can use the setMemeAttributes method I created as an extension for the UITextField type later.
    // However the text field is disabled so it can't be changed by the user.
    @IBOutlet weak var fontText: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
