//
//  SharedMemesTableViewController.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 22.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit

class SharedMemesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // The table view has to be reloaded when ViewController is dismissed which has to be done in viewWillAppear
        // as the SharedMemesTableViewController is not really unloaded but the ViewController is presented modally
        // on top of it which means that viewWillAppear will be called after ViewController is dismissed
        tableView.reloadData()
    }

    // MARK: - Table View Methods
    
    // MARK: - Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! MemeTableViewCell
        let currentMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        cell.memeImageView.image = currentMeme.memedImage
        cell.memeTextLabel.text = "\(currentMeme.topText)...\(currentMeme.bottomText)"
        return cell
    }
    
    // Implementing those two methods so rows in the table can be removed by swiping from right to left and
    // tapping on the "Delete" button
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // Check if the editingStyle is .Delete...
        if editingStyle == .Delete {
            // and if so, delete the selected meme from the model
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(indexPath.row)
            // and delete the row from the table with an animation
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        }
    }
    
    // MARK: - Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Push the MemeDetailViewController onto the navigation controller's stack
        // after passing it the selected meme
        let currentMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("memeDetailVC") as! MemeDetailViewController
        detailViewController.meme = currentMeme
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}
