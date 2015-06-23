//
//  MemeCollectionViewController.swift
//  Meme_2
//
//  Created by Jing Jia on 6/21/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import Foundation

import UIKit

class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {

    
    var memes: [Meme]!
    
    // MARK: Table View Data Source
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes

    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        
        // Set the name and image
        
        cell.label1?.text = meme.topText as String
        cell.imageView?.image = meme.memedImage
        if let detailTextLabel = cell.label2 {
            detailTextLabel.text = meme.bottomText
        }
        
        return cell
        }
        func documentsDirectory() -> String {
            let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
            return documentsFolderPath
        }
        // Get path for a file in the directory
        
        func fileInDocumentsDirectory(filename: String) -> String {
            return documentsDirectory().stringByAppendingPathComponent(filename)
        }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}
