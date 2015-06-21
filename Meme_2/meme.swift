//
//  meme.swift
//  Meme
//
//  Created by Jing Jia on 6/16/15.
//  Copyright (c) 2015 Jing Jia. All rights reserved.
//


import Foundation
import UIKit


struct Meme {
    
    var topText: NSString
    var bottomText: NSString
    //var imageRep: NSData
    var imageName: NSString
    
    static let TopText = "Top"
    static let BottomText = "Bottom"
    static let ImageName = "0"
    
    // Generate a Meme from a three entry dictionary
    
    init(dictionary: [String : String])
    {
    
        self.topText = dictionary[Meme.TopText]!
        self.bottomText = dictionary[Meme.BottomText]!
        self.imageName = dictionary[Meme.ImageName]!
    }
}

extension Meme {
    
    // Generate an array full of all of the Memes in
    static var allMemes: [Meme] {
        
        var MemeArray = [Meme]()
        
        for d in Meme.localMemeData() {
            MemeArray.append(Meme(dictionary: d))
        }
        
        return MemeArray
    }
    
    static func localMemeData() -> [[String : String]] {
        return [
            [Meme.TopText : "Maker: Sophia", Meme.BottomText : "Class: Art",  Meme.ImageName : "Doll"]        ]
    }
}
