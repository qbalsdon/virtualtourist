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
    
    var currentPin : Pin? = nil
    
    @IBOutlet weak var travelMapView: MKMapView!
    @IBOutlet weak var newCollectionButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annotation = MKPointAnnotation()
        annotation.title="New Location"
        annotation.coordinate = CLLocationCoordinate2D(latitude: (currentPin?.latitude)!, longitude: (currentPin?.longitude)!)
        travelMapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 200, 200)
        travelMapView.setRegion(viewRegion, animated: true)        
    }
    
    override func viewDidAppear(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
        if currentPin?.images.count == 0 {
            newCollectionButton.enabled = false
            FlickrAPI.findImagesForLocation(CLLocationCoordinate2D(latitude: (currentPin?.latitude)!, longitude: (currentPin?.longitude)!), radius: 20, page: 0, onSuccess: onFlickrImagesReceived, onError: onFlickrError)
        }
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
        newCollectionButton.enabled = true
        for image in images {
            let imageDict: [String : AnyObject] = [
                Photo.Keys.ImageURL: image.url
            ]
            
            let image = Photo(dictionary: imageDict, context: CoreDataStackManager.sharedInstance().managedObjectContext)
            image.pin = currentPin
        }
        CoreDataStackManager.sharedInstance().saveContext()
        collectionView.reloadData()
    }
    
    func onFlickrError(message: String!){
        newCollectionButton.enabled = true
    }
    
    @IBAction func newCollectionButtonPressed(sender: AnyObject) {
        newCollectionButton.enabled = false
        /*currentLocation.page = currentLocation.page+1
        FlickrAPI.findImagesForLocation(currentLocation.coordinate, radius: 20, page:currentLocation.page, onSuccess: onFlickrImagesReceived, onError: onFlickrError)*/
    }
    
    //MARK: UICollectionView
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cellId", forIndexPath: indexPath) as! FlickrImageCollectionViewCell
        let photo = currentPin?.images[indexPath.row]
        
        if let image = FlickrAPI.Caches.imageCache.imageWithIdentifier((photo?.imageURL)!) {
            cell.image.image = image
            print("Loaded from memory")
        } else {
            print("Downloading! \(photo?.imageURL)")
            cell.image.image = UIImage(named: "Download")
            
            FlickrAPI.downloadImageForCellAsync(photo?.imageURL) { (data) -> () in
                dispatch_async(dispatch_get_main_queue(), {
                    if data != nil {
                        let image = UIImage(data: data!)
                        cell.image.image = image
                        
                        FlickrAPI.Caches.imageCache.storeImage(image!, withIdentifier: (photo?.imageURL)!)
                        print("    Saved!")
                    }
                })
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //currentLocation.images.removeAtIndex(indexPath.row)
        collectionView.deleteItemsAtIndexPaths([indexPath])
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (currentPin?.images.count)!
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width:115, height:115)
    }
    
}
