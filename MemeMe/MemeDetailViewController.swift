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
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBAction func presentMemeEditor() {
        let viewController = storyboard?.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
        if let meme = meme {
            viewController.meme = Meme(topText: meme.topText, bottomText: meme.bottomText, image: meme.image, memedImage: meme.memedImage)
        }
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    @IBAction func shareExistingMeme() {
        if let meme = meme {
            meme.share(withShareButton: shareButton, onViewController: self)
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
