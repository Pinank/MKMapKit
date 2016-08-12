//
//  ViewController.swift
//  MKMapKitDemo
//
//  Created by smartSense on 15/07/16.
//  Copyright © 2016 smartSense. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIAlertViewDelegate {
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var smartMapKit: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureMapKit()
    }
    
    override func viewWillAppear(animated: Bool) {
        configureLocationManager()
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: Setup MapKit
    
    func configureMapKit() {
        
        //Set map gelegate and allow user locations to yes in order to show the current location point.
        
        smartMapKit.delegate = self
        smartMapKit.showsUserLocation = true
    }
    
    // MARK: Setup Location Manager
    
    func configureLocationManager(){
        
        //Set Location manager properties in order to get the user current location.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            if (CLLocationManager.authorizationStatus() == .NotDetermined) {
                locationManager.requestAlwaysAuthorization()
            } else if (CLLocationManager.authorizationStatus() == .Denied || CLLocationManager.authorizationStatus() == .Restricted) {
                showLocationEnableAlert()
            }
        } else {
            showLocationEnableAlert()
        }
    }
    
    // MARK: Location Manager Delegates
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedWhenInUse || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.AuthorizedAlways ){
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first)
        if let currentLocation = locations.last {
            let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
            smartMapKit.setRegion(region, animated: true)
        } else {
            self.showAlert("", message: "Failed to get your current location.")
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        showAlert("", message: "Fail to get current location")
    }
    
    // Show Alert
    
    func showAlert(title : String , message : String) {
        let alertViewController = UIAlertController(title: title, message:message , preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (action) in}
        alertViewController.addAction(okAction)
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    // Show Location Service Not Enable Alert
    
    func showLocationEnableAlert() {
        let alertViewController = UIAlertController(title: "Enable", message: "Location Services?", preferredStyle: .Alert)
        let cancelButton = UIAlertAction(title: "NO", style: .Cancel) { (action) in
            alertViewController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertViewController.addAction(cancelButton)
        
        let otherButton = UIAlertAction(title: "YES", style: .Default) { (action) in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        alertViewController.addAction(otherButton)
        self.presentViewController(alertViewController, animated: true, completion: nil)
    }
    
    // MARK:
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

