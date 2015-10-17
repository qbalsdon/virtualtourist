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
    
    var coord: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var imageDataSource: [FlickrImage] = []
    var currentPage = 1
    
    @IBOutlet weak var travelMapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.title="New Location"
        annotation.coordinate = coord
        travelMapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord, 200, 200)
        travelMapView.setRegion(viewRegion, animated: true)
        newCollectionButton.enabled = false
        FlickrAPI.findImagesForLocation(coord, radius: 20, page:currentPage, onSuccess: onFlickrImagesReceived, onError: onFlickrError)
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
        imageDataSource = images
        collectionView.reloadData()
        newCollectionButton.enabled = true
    }
    
    func onFlickrError(message: String!){
        newCollectionButton.enabled = true
    }
    
    @IBAction func newCollectionButtonPressed(sender: AnyObject) {
        newCollectionButton.enabled = false
        currentPage = currentPage + 1
        FlickrAPI.findImagesForLocation(coord, radius: 20, page:currentPage, onSuccess: onFlickrImagesReceived, onError: onFlickrError)
    }
    
    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! FlickrImageCollectionViewCell
        let image = imageDataSource[indexPath.row]
        
        cell.image.image = UIImage(named: "Download")
        
        FlickrAPI.downloadImageForCellAsync(image.url, cellToUpdate: cell)
        
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:115, height:115)
    }
    
}
