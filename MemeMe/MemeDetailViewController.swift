//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 25.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme?
    
    // MARK: - Outlets and Actions
    @IBOutlet weak var memedImageView: UIImageView!
    
    @IBAction func presentMemeEditor() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
        if let meme = meme {
            viewController.meme = Meme(topText: meme.topText, bottomText: meme.bottomText, image: meme.image, memedImage: meme.memedImage)
        }
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func shareExistingMeme() {
        // When the "Share" button is tapped:
        // - Create an instance of a UIActivityViewController
        if let meme = meme {
            let activityViewController = UIActivityViewController(activityItems: [meme.memedImage], applicationActivities: nil)
        
            activityViewController.completionWithItemsHandler = {
                (activity, success, items, error) in
                // If it was a success - which means that the action could be performed the current view controller should be popped off the 
                // navigation controller
                if success {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    // If it didn't succeed - which is also the case if the cancel button is pressed in the activity view controller -
                    // only the activity view controller should be dismissed, the detail view controller however should still be displayed
                    activityViewController.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            presentViewController(activityViewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        memedImageView.image = meme?.memedImage
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.hidden = false
    }
    
}
