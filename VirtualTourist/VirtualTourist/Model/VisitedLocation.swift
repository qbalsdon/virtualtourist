//
//  VisitedLocation.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/10/17.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import MapKit

class VisitedLocation: MKPointAnnotation {
    var images: [FlickrImage]
    var page: Int
    
    override init() {
        page = 1
        images = []
        super.init()
        coordinate = CLLocationCoordinate2D()
    }
    
    init(coord: CLLocationCoordinate2D){
        page = 1
        images = []
        super.init()
        title="New Location"
        coordinate = coord
    }
    
    func getImages(){
        FlickrAPI.findImagesForLocation(coordinate, radius: 20, page:page, onSuccess: onFlickrImagesReceived, onError: onFlickrError)
    }
    
    func onFlickrImagesReceived(flickrImages: [FlickrImage]){
        images = flickrImages
    }
    
    func onFlickrError(message: String!){
        print("VisitedLocation object error: Cannot get images: \(message)")
    }

}
