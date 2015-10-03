//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/09/29.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController {
    
    var coord: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Got location [\(coord.latitude), \(coord.longitude)]")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
