//
//  Meme.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 12.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    let topText: String
    let bottomText: String
    let image: UIImage
    let memedImage: UIImage
    
    static func saveMeme(topText: String, bottomText: String, image: UIImage, memedImage: UIImage) {
        let memedImage = memedImage
        let meme = Meme(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
        
        // Update the shared model that lays in the AppDelegate by appending the saved meme to the memes array
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }
    
}