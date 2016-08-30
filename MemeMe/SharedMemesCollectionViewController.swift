//
//  SharedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Tobias Helmrich on 22.08.16.
//  Copyright © 2016 Tobias Helmrich. All rights reserved.
//

import UIKit

class SharedMemesCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var sharedMemesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let availableSpace = self.view.frame.width
        let sizeOfItem = CGSize(width: availableSpace / 4.1, height: availableSpace / 4.1)
        
        flowLayout.itemSize = sizeOfItem
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 2
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sharedMemesCollectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath)
        let imageView = UIImageView(image:  (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row].memedImage)
        cell.backgroundView = imageView
        cell.backgroundView?.contentMode = .ScaleAspectFit
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Push the MemeDetailViewController onto the navigation controller's stack
        // after passing it the selected meme
        let currentMeme = (UIApplication.sharedApplication().delegate as! AppDelegate).memes[indexPath.row]
        let detailViewController = storyboard?.instantiateViewControllerWithIdentifier("memeDetailVC") as! MemeDetailViewController
        detailViewController.meme = currentMeme
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    
    
}
