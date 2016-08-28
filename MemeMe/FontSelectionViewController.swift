//
//  FontSelectionViewController.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 16.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit

class FontSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var fonts = [[String: String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get all the available fonts by checking which fonts are provided by the application
        var availableFonts = NSBundle.mainBundle().objectForInfoDictionaryKey("UIAppFonts") as! [String]
        // Add the default font (Helvetica Neue Condensed Black) manually because it's not provided in the Info.plist but as a system default
        availableFonts.append("HelveticaNeue-CondensedBlack")
        
        // Iterate over all the available fonts and create two versions: One without the .ttf ending which will be used to create
        // a UIFont object later and one "clean" version without hyphens that will be used for the preview of the font in the
        // FontSelectionViewController. After that append a dictionary with the first version as a key and the "clean" version as
        // a value and append this dictionary to the fonts array
        var index = 0
        for font in availableFonts {
            let fontNameWithoutFileType = font.stringByReplacingOccurrencesOfString(".ttf", withString: "")
            let cleanFontName = fontNameWithoutFileType.stringByReplacingOccurrencesOfString("-", withString: " ")
            
            fonts.append([fontNameWithoutFileType: cleanFontName])
            
            index += 1
        }
    }
    
    @IBAction func dismissFontSelection() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - TableView functions
    
    // MARK: - Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fonts.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("fontCell") as! FontTableViewCell
        let currentFont = fonts[indexPath.row]
        for (fontName, cleanFontName) in currentFont {
            cell.fontText.text = cleanFontName
            cell.fontText.setMemeAttributes(withFont: fontName, size: 30, alignment: .Left)
        }
        return cell
    }
    
    // MARK: - Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the presenting view controller
        let presentingVC = self.presentingViewController as! ViewController
        // Get the font of the row that was selected
        let currentFont = fonts[indexPath.row]
        for (fontName, _) in currentFont {
            // Set the memeTopTextField and memeBottomTextField properties of the ViewController
            presentingVC.memeTopTextField.setMemeAttributes(withFont: fontName, size: 40, alignment: .Center)
            presentingVC.memeBottomTextField.setMemeAttributes(withFont: fontName, size: 40, alignment: .Center)
        }
        // After setting the meme textfields' text dismiss this modal view controller
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Additional functions
    
    // This function hides the status bar in this view controller
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
}
