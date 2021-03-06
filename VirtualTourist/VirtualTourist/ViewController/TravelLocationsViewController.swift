//
//  TravelLocationsViewController.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/09/26.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TravelLocationsViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var travelMapView: MKMapView!
    
    var pins = [Pin]()
    var currentPin : Pin? = nil
    
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
                let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(center_lat, center_lon), span: MKCoordinateSpan(latitudeDelta: span_lat, longitudeDelta: span_lon))
                travelMapView.setRegion(region, animated: true)
        }
        
        
        //runTestForData()
    }
    
    override func viewWillAppear(animated: Bool) {
        travelMapView.removeAnnotations(travelMapView.annotations)
        let allPins = fetchAllPins()
        for pin in allPins {
            addPinToMap(pin)
        }
    }
    
    func fetchAllPins() -> [Pin] {
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        do {
            return try CoreDataStackManager.sharedInstance.managedObjectContext.executeFetchRequest(fetchRequest) as! [Pin]
        } catch  let error as NSError {
            print("Error in fetchAllPins(): \(error)")
            return [Pin]()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let defs = NSUserDefaults.standardUserDefaults()
        defs.setValue(mapView.region.center.latitude, forKey: LOCATION_LAT)
        defs.setValue(mapView.region.center.longitude, forKey: LOCATION_LON)
        defs.setValue(mapView.region.span.latitudeDelta, forKey: SPAN_LAT)
        defs.setValue(mapView.region.span.longitudeDelta, forKey: SPAN_LON)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
        pinAnnotationView.canShowCallout = false
        pinAnnotationView.animatesDrop = true
        
        return pinAnnotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        let location = view.annotation as! PinAnnotation
        
        currentPin = location.pin
        
        performSegueWithIdentifier("photoAlbumSegue", sender: self)
    }
    
    func addPinToMap(pin: Pin) {
        
        let annotation = PinAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        annotation.pin = pin
        travelMapView.addAnnotation(annotation)
    }
    
    @IBAction func mapViewTapped(sender: AnyObject) {
        if let recognizer = sender as? UIGestureRecognizer {
            
            if recognizer.state == UIGestureRecognizerState.Ended{
                let point = recognizer.locationInView(travelMapView)
                
                let coord = travelMapView.convertPoint(point, toCoordinateFromView: travelMapView)
                
                let dictionary: [String : AnyObject] = [
                    Pin.Keys.Latitude : coord.latitude,
                    Pin.Keys.Longitude : coord.longitude
                ]
                
                let pinToBeAdded = Pin(dictionary: dictionary, context: CoreDataStackManager.sharedInstance.managedObjectContext)
                CoreDataStackManager.sharedInstance.saveContext()
                addPinToMap(pinToBeAdded)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "photoAlbumSegue" {
            if let vc = segue.destinationViewController as? PhotoAlbumViewController {
                vc.currentPin = currentPin
            }
        }
    }
}
