//
//  ViewController.swift
//  Meme_2
//
//  Created by Jing Jia on 6/18/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var topText: UITextField!

    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName :  UIColor.whiteColor(),
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : 5
    ]
    
    var allMemes : [Meme]  = [Meme]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.delegate=self
        self.topText.delegate=self
      //  self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Memecell")
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allMemes.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
      
        let meme = self.allMemes[indexPath.row]
        cell.textLabel?.font =
            UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        cell.textLabel?.text = meme.topText as String
        
        let imagePath = fileInDocumentsDirectory(meme.imageName as String)
        let image = loadImageFromPath(imagePath)
        cell.imageView?.image = image
        //cell.imageView?.image = UIImage(named: meme.imageName as String)
        
        
        if let detailTextLabel = cell.detailTextLabel {
            detailTextLabel.text = "Made at: \(meme.bottomText)"
        }
        
        return cell
    }
   // func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    //       let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
     //         detailController.meme = allMemes[indexPath.row]
      //        self.navigationController!.pushViewController(detailController, animated: true)
       //     println("You selected cell #\(indexPath.row)!")
       //  }
        

    
    @IBAction func moveKeyboard(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
        
    }
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y += getKeyboardHeight(notification)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("photo library")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            
            //imag.allowsEditing = false
            self.presentViewController(imag, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image=chosenImage
        imageView.contentMode = .ScaleAspectFit
        //imagePickerView.contentMode = .ScaleAspectFill
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    
    
    @IBAction func shareMeme(sender: AnyObject) {
        var topTextStr:String  = topText.text!
        var img: UIImage = imageView.image!
        var bottomTextStr:String = bottomText.text!
        
        
        var shareItems:Array = [topTextStr, img, bottomTextStr]
        
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func saveMeme(sender: AnyObject){
        
        var img: UIImage = imageView.image!
        
        var myImageName: String! = String(allMemes.count)
        //var myImageName: String! = "1"
        let imagePath = fileInDocumentsDirectory(myImageName)
        
        let smlImg=resizeImage ( img, newHeight: 20.0)
        
        println(imagePath)
        saveImage(smlImg, path: imagePath)
        
        
      let newMeme = Meme(dictionary: [Meme.TopText : topText.text, Meme.BottomText : bottomText.text,  Meme.ImageName : myImageName] )
          allMemes.append(newMeme)
        
        for d in allMemes {
            
            println(d.topText,"  +  ", d.imageName, "   +   ", d.bottomText)
        }

        
    }
    
    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {
        
        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData.writeToFile(path, atomically: true)
        return result
        
    }
    
   
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            println("missing image at: (path)")
        }
        // println("(path)")
        return image
        
    }
    func documentsDirectory() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        return documentsFolderPath
    }
    // Get path for a file in the directory
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return documentsDirectory().stringByAppendingPathComponent(filename)
    }

}

