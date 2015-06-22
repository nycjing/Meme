//
//  MemeDetailViewController.swift
//  Meme_2
//
//  Created by Jing Jia on 6/21/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//


import UIKit

class MemeDetailViewController : UIViewController {
    
    @IBOutlet weak var label1: UILabel!

    
    @IBOutlet weak var imageView: UIImageView!
    var meme: Meme!
    
    @IBOutlet weak var label2: UILabel!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.label1.text = self.meme.topText as String
        self.label2.text = self.meme.bottomText as String
        self.tabBarController?.tabBar.hidden = true
        let imagePath = fileInDocumentsDirectory(meme.imageName as String)
        let image = loadImageFromPath(imagePath)
        self.imageView!.image = image
         }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        return documentsFolderPath
    }
    // Get path for a file in the directory
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
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