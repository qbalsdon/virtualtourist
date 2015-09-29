//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/09/26.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import MapKit

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var travelMapView: MKMapView!
    
    let SPAN_LAT = "SPAN_LAT"
    let SPAN_LON = "SPAN_LON"
    let LOCATION_LAT = "LOCATION_LAT"
    let LOCATION_LON = "LOCATION_LON"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defs = NSUserDefaults.standardUserDefaults()
        if
            let center_lat = defs.valueForKey(LOCATION_LAT) as? CLLocationDegrees,
            let center_lon = defs.valueForKey(LOCATION_LON) as? CLLocationDegrees,
            let span_lat = defs.valueForKey(SPAN_LAT) as? CLLocationDegrees,
            let span_lon = defs.valueForKey(SPAN_LON) as? CLLocationDegrees {
                print("I found \(center_lat) - \(center_lon) - \(span_lat) - \(span_lon)")
                let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(center_lat, center_lon), span: MKCoordinateSpan(latitudeDelta: span_lat, longitudeDelta: span_lon))
                travelMapView.setRegion(region, animated: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("Location changed")
        let defs = NSUserDefaults.standardUserDefaults()
        defs.setValue(mapView.region.center.latitude, forKey: LOCATION_LAT)
        defs.setValue(mapView.region.center.longitude, forKey: LOCATION_LON)
        defs.setValue(mapView.region.span.latitudeDelta, forKey: SPAN_LAT)
        defs.setValue(mapView.region.span.longitudeDelta, forKey: SPAN_LON)
    }
}