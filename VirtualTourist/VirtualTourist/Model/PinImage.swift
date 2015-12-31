//
//  PinImage.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/12/30.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import CoreData

class PinImage: NSManagedObject {
    struct Keys {
        static let ImageURL = "imageURL"
    }
    
    @NSManaged var imageURL: String
    @NSManaged var pin: Pin?
    
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String : AnyObject], context: NSManagedObjectContext) {
        
        // Core Data
        let entity =  NSEntityDescription.entityForName("PinImage", inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        // Dictionary
        imageURL = dictionary[Keys.ImageURL] as! String
    }
    
    var image: UIImage? {
        
        get {
            return FlickrAPI.Caches.imageCache.imageWithIdentifier(imageURL)
        }
        
        set {
            FlickrAPI.Caches.imageCache.storeImage(newValue, withIdentifier: imageURL)
        }
    }
}
