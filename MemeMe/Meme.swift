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
    
    func share(withShareButton shareButton: UIBarButtonItem, onViewController viewController: UIViewController) {
        // - Create an instance of a UIActivityViewController
        let activityViewController = UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
        
        // - Call the saveMeme() function in the activity view controller's completion handler after optionally unwrapping
        // the text fields' and imageView's values
        activityViewController.completionWithItemsHandler = {
            (activity, success, items, error) in
            // If it was a success - which means that the action could be performed the whole editing view controller should be dismissed
            if success {
                Meme.saveMeme(self.topText, bottomText: self.bottomText, image: self.image, memedImage: self.memedImage)
                viewController.dismissViewControllerAnimated(true, completion: nil)
            } else {
                // If it didn't succeed - which is also the case if the cancel button is pressed in the activity view controller -
                // only the activity view controller should be dismissed, the editing view controller however should still be displayed
                activityViewController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        // The activityViewController's popoverPresentationController has to be set in order to work for iPads
        activityViewController.popoverPresentationController?.barButtonItem = shareButton
        // - Present the activity view controller
        viewController.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
}