//
//  MemeEditorViewControll.swift
//  Meme_2
//
//  Created by Jing Jia on 6/22/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    @IBOutlet weak var topText: UITextField!
    
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName :  UIColor.whiteColor(),
        NSForegroundColorAttributeName : UIColor.blackColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSStrokeWidthAttributeName : 5
    ]
    
    
    //var memedImage: UIImage!
    var memes: [Meme]!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        self.bottomText.delegate=self
        self.topText.delegate=self
           }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
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
         self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        var topTextStr = topText.text!
        var img: UIImage = imageView.image!
        var bottomTextStr = bottomText.text!
        
        
        var shareItems:Array = [topTextStr, img, bottomTextStr]
        //var shareItems:UIImage =generateMemedImage()
        let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func save() {

        var meme=Meme(topText: topText, bottomText: bottomText, originalimage: imageView.image!, memedImage: generateMemedImage())
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        println(memes.count)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }

    
    func generateMemedImage() -> UIImage
    {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        
        //navigationController?.setToolbarHidden(navigationController?.toolBarHidden == false, animated: true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == true, animated: true)
        
        self.navigationController?.navigationBarHidden = false
         
        
        return memedImage
    }
    
   // @IBAction func saveMeme(sender: AnyObject){
        
     //   var img: UIImage = imageView.image!
        
       // var myImageName: String! = String(allMemes.count)
        //var myImageName: String! = "1"
      //  let imagePath = fileInDocumentsDirectory(myImageName)
        
      //  let smlImg=resizeImage ( img, newHeight: 20.0)
        
      //  println(imagePath)
      //  saveImage(smlImg, path: imagePath)
        
        
      //  let newMeme = Meme(dictionary: [Meme.TopText : topText.text, Meme.BottomText : bottomText.text,  Meme.ImageName : myImageName] )
       // allMemes.append(newMeme)
        
       // for d in allMemes {
            
         //   println(d.topText,"  +  ", d.imageName, "   +   ", d.bottomText)
       // }
        
        
    //}
    
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

