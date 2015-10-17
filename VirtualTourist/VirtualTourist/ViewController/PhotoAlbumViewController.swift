//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Quintin Balsdon on 2015/09/29.
//  Copyright © 2015 Quintin Balsdon. All rights reserved.
//

import UIKit
import MapKit

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var currentLocation: VisitedLocation = VisitedLocation()
    
    @IBOutlet weak var travelMapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.title="New Location"
        annotation.coordinate = currentLocation.coordinate
        travelMapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 200, 200)
        travelMapView.setRegion(viewRegion, animated: true)        
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

    func onFlickrImagesReceived(images: [FlickrImage]){
        currentLocation.images = images
        collectionView.reloadData()
        newCollectionButton.enabled = true
    }
    
    func onFlickrError(message: String!){
        newCollectionButton.enabled = true
    }
    
    @IBAction func newCollectionButtonPressed(sender: AnyObject) {
        newCollectionButton.enabled = false
        currentLocation.page = currentLocation.page+1
        FlickrAPI.findImagesForLocation(currentLocation.coordinate, radius: 20, page:currentLocation.page, onSuccess: onFlickrImagesReceived, onError: onFlickrError)
    }
    
    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! FlickrImageCollectionViewCell
        let image = currentLocation.images[indexPath.row]
        
        cell.image.image = UIImage(named: "Download")
        
        FlickrAPI.downloadImageForCellAsync(image.url) { (data) -> () in
            dispatch_async(dispatch_get_main_queue(), {
                if data != nil {
                    let image = UIImage(data: data!)
                    cell.image.image = image
                }
            })
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentLocation.images.removeAtIndex(indexPath.row)
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentLocation.images.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:115, height:115)
    }
    
}
