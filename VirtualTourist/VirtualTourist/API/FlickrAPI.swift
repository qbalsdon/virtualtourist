//
//  FlickrAPI.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/10/03.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import MapKit

class FlickrAPI: NSObject {
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> FlickrAPI {
        
        struct Singleton {
            static var sharedInstance = FlickrAPI()
        }
        
        return Singleton.sharedInstance
    }
    
    // MARK: - Shared Image Cache
    
    struct Caches {
        static let imageCache = ImageCache()
    }
    
    class func findImagesForLocation(location: CLLocationCoordinate2D, radius: Int, page: Int, onSuccess:([FlickrImage]) -> (), onError:(String!)->()){
        
        let BASE_URL = "https://api.flickr.com/services/rest/"
        let METHOD_NAME = "flickr.photos.search"
        let EXTRAS = "url_m"
        let DATA_FORMAT = "json"
        let NO_JSON_CALLBACK = "1"
        
        var keys: NSDictionary?
        var apiKey: String!
        
        if let path = NSBundle.mainBundle().pathForResource("ApiKeys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
        if let _ = keys {
            apiKey = keys?["FLICKR_PUBLIC_KEY"] as? String
        }
        
        let methodArguments = [
            "method": METHOD_NAME,
            "api_key": apiKey,
            "lat": location.latitude,
            "lon": location.longitude,
            "privacy_filter" : 1,
            "radius": radius,
            "extras": EXTRAS,
            "format": DATA_FORMAT,
            "per_page": "12",
            "nojsoncallback": NO_JSON_CALLBACK,
            "page" : page
        ]
        
        let session = NSURLSession.sharedSession()
        let urlString = BASE_URL + escapedParameters(methodArguments as! [String : AnyObject])
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        
        let task = session.dataTaskWithRequest(request) {data, response, downloadError in
            if let error = downloadError {
                print("Could not complete the request \(error)")
                dispatch_async(dispatch_get_main_queue(), {
                    onError("Unable to connect to Flickr API")
                })
            } else {
                var parsedResult: AnyObject!
                do {
                    parsedResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                } catch {
                    print("Error parsing response")
                    dispatch_async(dispatch_get_main_queue(), {
                        onError("Unknown response from the Flickr API")
                    })
                    return;
                }
                //print("Received the following: \(parsedResult)")
                if let photosDictionary = parsedResult.valueForKey("photos") as? NSDictionary {
                    
                    if let photoCount = photosDictionary["total"] as? String{
                        let count = (photoCount as NSString).integerValue
                        if (count <= 0){
                            dispatch_async(dispatch_get_main_queue(), {
                                onSuccess([FlickrImage]())
                            })
                            return
                        }
                    }
                    
                    if let photoArray = photosDictionary.valueForKey("photo") as? [[String: AnyObject]] {
                        var imageArray = [FlickrImage]()
                        for photo in photoArray {
                            let photoTitle = photo["title"] as? String
                            let imageUrlString = photo["url_m"] as? String
                            
                            imageArray.append(FlickrImage(imageTitle: photoTitle, imageUrl: imageUrlString))
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            onSuccess(imageArray)
                        })
                    } else {
                        print("Cant find key 'photo' in \(photosDictionary)")
                        dispatch_async(dispatch_get_main_queue(), {
                            onError("Flickr API response error: photo not found")
                        })
                    }
                } else {
                    print("Cant find key 'photos' in \(parsedResult)")
                    dispatch_async(dispatch_get_main_queue(), {
                        onError("Flickr API response error: photo list not found")
                    })
                }
            }
        }
        task.resume()
    }
    
    //MARK: Helper Methods
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        var urlVars = [String]()
        for (key, value) in parameters {
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func downloadImageForCellAsync(imageURL: String!, onComplete:(NSData?) -> ()){
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(NSURL(string: imageURL)!) { (data, response, error) -> Void in
            if error == nil {
                onComplete(data)
            } else {
                onComplete(nil)
                print("Cannot download image")
            }
        }
        task.resume()
    }
}
