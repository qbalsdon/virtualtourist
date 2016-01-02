//
//  PinImage.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/12/30.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import CoreData

class Photo: NSManagedObject {
    struct Keys {
        static let FilePath = "imageURL"
        static let ImageURL = "filePath"
    }
    
    @NSManaged var imageURL: String
    @NSManaged var filePath: String
    @NSManaged var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("Photo", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        imageURL = dictionary[Keys.ImageURL] as! String
        if dictionary[Keys.FilePath] != nil {
            filePath = dictionary[Keys.FilePath] as! String
        }
    }
    
    var image: UIImage? {
        
        get {
            return FlickrAPI.imageCache.imageWithIdentifier(imageURL)
        }
        
        set {
            FlickrAPI.imageCache.storeImage(newValue, withIdentifier: imageURL)
        }
    }
}
