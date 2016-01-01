//
//  ImageCache.swift
//  VirtualTourist
//
//  Modified by Quintin Balsdon on 2015/12/30.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit

class ImageCache {
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    // MARK: - Saving images
    
    func storeImage(image: UIImage?, withIdentifier identifier: String) -> String {
        let path = pathForIdentifier(identifier)
        
        if image == nil {
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            
            return ""
        }
        
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
        
        return path
    }

    func removeImage(withIdentifier identifier: String) -> Bool {
        let path = pathForIdentifier(identifier)
        
        do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch _ {
            return false
        }
        
        return true
    }
    
    func removeImage(withPath path: String) -> Bool {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch _ {
            return false
        }
        
        return true
    }

    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let removedScheme = identifier.stringByReplacingOccurrencesOfString("https://", withString: "")
        let id = removedScheme.stringByReplacingOccurrencesOfString("/", withString: "_")
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(id)
        
        return fullURL.path!
    }
}
