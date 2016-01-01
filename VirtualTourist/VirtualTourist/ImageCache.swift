//
//  ImageCache.swift
//  VirtualTourist
//
//  Modified by Quintin Balsdon on 2015/12/30.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit

class ImageCache {
    
    /*func documentsDirectory() -> String {
        return NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
    }
    
    func getFileRef(path: String) -> String {
        return path//(NSURL(string: path)?.lastPathComponent)!
    }
    
    func saveImage(image: UIImage, path: String) -> Bool {
        let jpegImageData = UIImageJPEGRepresentation(image, 100.0)
        
        print("Saving \(documentsDirectory())\\\(getFileRef(path))")
        let result = jpegImageData!.writeToFile("\(documentsDirectory())/\(getFileRef(path))", atomically: true)
        return result
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        let data = NSData(contentsOfFile: "\(documentsDirectory())/\(getFileRef(path))")
        if data == nil {
            return nil
        }
        let image = UIImage(data: data!)
        return image
    }*/
    
    // MARK: - Retreiving images
    
    func imageWithIdentifier(identifier: String?) -> UIImage? {
        
        if identifier == nil || identifier! == "" {
            return nil
        }
        
        let path = pathForIdentifier(identifier!)
        
        print("Attempting to load from \(path)")
        
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
        
        print("Saving to \(path)")
        
        return path
    }
    
    // MARK: - Helper
    
    func pathForIdentifier(identifier: String) -> String {
        let removed = identifier.stringByReplacingOccurrencesOfString("https://", withString: "")
        
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(id)
        
        return fullURL.path!
    }
}
