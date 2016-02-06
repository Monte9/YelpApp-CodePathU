//
//  NearbyViewController.swift
//  YelpM
//
//  Created by Monte's Pro 13" on 2/6/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MBProgressHUD

class NearbyViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var businesses: [Business]!
    var locationManager : CLLocationManager!
    var currentLocation : CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        //use location manager to get the current location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 200
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        //    let centerLocation = CLLocation(latitude: 37.774865, longitude: -122.414137)
        
        //   let pinLocation = CLLocationCoordinate2DMake(37.774865, -122.414137)
        //   addAnnotationAtCoordinate(pinLocation)
        
        // goToLocation(centerLocation)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        //        //Example of Yelp search with more search options specified
        Business.searchWithTerm("restaurants", latitude: locationManager.location?.coordinate.latitude, longitude: locationManager.location?.coordinate.longitude, sort: .Distance, categories: [], deals: false, offset: nil, limit: 20) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            //            self.searchResults = self.businesses
            //            self.businessTableView.reloadData()
            //
            for business in businesses {
                let pinLocation = CLLocationCoordinate2DMake(business.latitude! as! Double!, business.longitude as! Double!)
                self.addAnnotationAtCoordinate(pinLocation, title: business.name!)
            }
            // Hide HUD once network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        
        //trying to drop a pin on user pressing
        var longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("handleGesture:"))
        longPressGesture.delegate = self
        longPressGesture.minimumPressDuration = 0.5 //user must press for 0.5 seconds
      //  longPressGesture.numberOfTapsRequired = 2
        mapView.addGestureRecognizer(longPressGesture)
        print("gesture added")
    }
    
    func handleGesture(sender: UILongPressGestureRecognizer) {
        if sender.state == .Ended {
            var touchPoint: CGPoint = sender.locationInView(mapView)

            var touchMapCoordinate: CLLocationCoordinate2D = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            
           var pointAnn = MKPointAnnotation()
            
            pointAnn.coordinate = touchMapCoordinate
         //   pointAnn.title = "This is a new pin! yay!"
            mapView.addAnnotation(pointAnn)
        }
    }
    


    //
    //    MKPointAnnotation *pa = [[MKPointAnnotation alloc] init];
    //    pa.coordinate = touchMapCoordinate;
    //    pa.title = @"Hello";
    //    [mapView addAnnotation:pa];
    //    [pa release];
    //    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "customAnnotationView"
        // custom pin annotation
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        else {
            annotationView!.annotation = annotation
        }
        if #available(iOS 9.0, *) {
            annotationView!.pinTintColor = UIColor.redColor()
            annotationView!.animatesDrop = true
        } else {
            annotationView!.pinColor = MKPinAnnotationColor.Red
            annotationView!.animatesDrop = true
        }
        
        return annotationView
    }
    
    public func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, didChangeDragState newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.1, 0.1)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            region.center
            mapView.setRegion(region, animated: false)
        }
    }
    
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        mapView.addAnnotation(annotation)
        //  print("annotation added")
    }
    
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        mapView.setRegion(region, animated: false)
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
