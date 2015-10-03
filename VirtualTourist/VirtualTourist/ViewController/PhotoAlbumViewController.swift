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
    
    @IBOutlet weak var travelMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.title="New Location"
        annotation.coordinate = coord
        travelMapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        travelMapView.setRegion(viewRegion, animated: true)
        
        FlickrAPI.findImagesForLocation(coord, radius: 20)
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        pinAnnotationView.canShowCallout = false
        pinAnnotationView.animatesDrop = true
        
        return pinAnnotationView
        
    }

}
