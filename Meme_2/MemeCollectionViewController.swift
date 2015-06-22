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

    let allMemes = Meme.allMemes
    
    
    // MARK: Table View Data Source
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = self.allMemes[indexPath.row]
        
        // Set the name and image
        
        cell.label1?.text = meme.topText as String
        
        let imagePath = fileInDocumentsDirectory(meme.imageName as String)
        let image = loadImageFromPath(imagePath)
        cell.imageView?.image = image

        
        if let detailTextLabel = cell.label2 {
            detailTextLabel.text = "Made at: \(meme.bottomText)"
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
        detailController.meme = self.allMemes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
            func loadImageFromPath(path: String) -> UIImage? {
            
            let image = UIImage(contentsOfFile: path)
            
            if image == nil {
                
                println("missing image at: (path)")
            }
            // println("(path)")
            return image
            
        }

}
