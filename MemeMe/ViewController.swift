//
//  ViewController.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 11.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: - Properties
    
    var meme: Meme?
    
    // MARK: - Outlets
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    @IBOutlet weak var albumBarButton: UIBarButtonItem!
    @IBOutlet weak var cameraBarButton: UIBarButtonItem!
    
    @IBOutlet weak var memeTopTextField: UITextField!
    @IBOutlet weak var memeBottomTextField: UITextField!
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    // MARK: - Instances of text field delegates
    
    let memeTopTextFieldDelegate = MemeTextFieldDelegate()
    let memeBottomTextFieldDelegate = MemeTextFieldDelegate()
    
    // This variable holds the information if the keyboard is currenty displayed or not
    var keyboardActive = false
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the text field's delegate and change its appearance
        memeTopTextField.delegate = memeTopTextFieldDelegate
        memeBottomTextField.delegate = memeBottomTextFieldDelegate
        memeTopTextField.setMemeAttributes(withFont: "HelveticaNeue-CondensedBlack", size: 40, alignment: .Center)
        memeBottomTextField.setMemeAttributes(withFont: "HelveticaNeue-CondensedBlack", size: 40, alignment: .Center)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // This unwraps the optional meme property and if it can be unwrapped it means that this view controller
        // is presented by the MemeDetailViewController which means that an existing meme should be edited so the
        // outlets' values are set to the existing meme's values
        // If it can't be unwrapped it means that no meme was passed so nothing should happen
        if let meme = meme {
            memeImageView.image = meme.image
            memeTopTextField.text = meme.topText
            memeBottomTextField.text = meme.bottomText
        }
        
        // Check if the used source types are available and
        // set its related bar button depending on this
        albumBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
        cameraBarButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        // Check if the image is set which indicates that it's an existing meme and enable the share button if that's the case
        // Otherwise it should be disabled as it's not a meme if there is no image
        shareButton.enabled = memeImageView.image != nil
        
        // Subscribe to receive keyboard notifications
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe from keyboard notifications
        unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Actions
    // MARK: - Toolbar Buttons
    @IBAction func selectImageFromAlbum() {
        presentImagePicker(withSourceType: .PhotoLibrary)
    }
    
    @IBAction func selectImageFromCamera() {
        presentImagePicker(withSourceType: .Camera)
    }
    
    @IBAction func shareMeme() {
        // When the "Share" button is tapped:
        // - Generate a memed image
        let memedImage = generateMemedImage()
        
        if let topText = memeTopTextField.text,
        bottomText = memeBottomTextField.text,
            image = memeImageView.image {
            let meme = Meme(topText: topText, bottomText: bottomText, image: image, memedImage: memedImage)
            meme.share(withShareButton: shareButton, onViewController: self)
        }
    }
    
    
    
    // This action will be triggered when the cancel button is pressed
    @IBAction func resetMeme() {
        // Set the text fields' values to the default values and the image to nil
        memeTopTextField.text = "TOP"
        memeBottomTextField.text = "BOTTOM"
        memeImageView.image = nil
        
        resignFirstResponderOfMemeTextFields()
        
        // When the cancel button is pressed, this view controller should be dismissed after all the values are reset
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UIImagePickerController delegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Safely downcast the original image we receive by using the UIImagePickerControllerOriginalImage key with the
        // info dictionary to a UIImage and assign the resulting image to the memeImageView's image property
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            memeImageView.image = image
        }
        
        // Enable the Share button because the user has now chosen an image that can be shared
        shareButton.enabled = true
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Functions to move the view when the keyboard is displayed (Notifications)
    
    // Subscribes view controller to receive notifications when the keyboard is displayed or hidden
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardStatusChanged(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardStatusChanged(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Unsubscribes view controller to receive notifications when the keyboard is displayed or hidden
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardStatusChanged(notification: NSNotification) {
        let keyboardHeight = getKeyboardHeight(notification)
        // The following if-statement checks which notification was sent and whether the keyboard is currently active or not.
        // It also checks if the memeBottomTextField is the first responders which means that it's selected. This is checked because
        // otherwise the topTextField would disappear even though it is the selected text field.
        // After changing the view's frame's y-position it resets the keyboardActive variable to keep track of the current state of
        // the keyboard. This is neccessary because otherwise the view would always be moved up when the user directly goes from
        // one text field to the other without dismissing the keyboard.
        if notification.name == UIKeyboardWillShowNotification && keyboardActive == false && memeBottomTextField.isFirstResponder() {
            // Move the view up by the keyboard's height
            self.view.frame.origin.y -= keyboardHeight
            keyboardActive = true
        } else if notification.name == UIKeyboardWillHideNotification && keyboardActive == true && memeBottomTextField.isFirstResponder() {
            // Move the view down again
            self.view.frame.origin.y += keyboardHeight
            keyboardActive = false
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // Get the keyboard's height by using the UIKeyboardFrameEndUserInfoKey with the userInfo dictionary received with the notification
        let userInfo = notification.userInfo
        let keyboardFrameEnd = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardFrameEnd.CGRectValue().height
    }
    
    // MARK: - Additional functions
    
    // This function hides the status bar in this view controller
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func generateMemedImage() -> UIImage {
        // Hide elements that shouldn't appear on the memed image
        // (e.g. toolbar, buttons, etc.)
        toolBarTop.hidden = true
        toolBarBottom.hidden = true
        
        // Also resign the first responder so the cursor won't appear on the memed image
        resignFirstResponderOfMemeTextFields()
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show previously hidden elements again
        toolBarTop.hidden = false
        toolBarBottom.hidden = false
        
        return memedImage
    }
    
    // This function takes a source type as a parameter and will then present a UIImagePickerController with the appropriate source type
    func presentImagePicker(withSourceType sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    // This checks which text field is currently selected and if a text field is selected the first responders is resigned
    func resignFirstResponderOfMemeTextFields() {
        if memeTopTextField.isFirstResponder() {
            memeTopTextField.resignFirstResponder()
        } else if memeBottomTextField.isFirstResponder() {
            memeBottomTextField.resignFirstResponder()
        }
    }

}






