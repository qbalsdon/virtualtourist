//
//  FlickrImage.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/10/17.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit

class FlickrImage: NSObject {
    var title: String!
    var url: String!
    
    override init(){
        title = nil
        url = nil
    }
    
    init(imageTitle: String!, imageUrl: String!){
        title = imageTitle
        url = imageUrl
    }
}
