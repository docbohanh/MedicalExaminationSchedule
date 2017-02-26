//
//  ServiceLocationViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 1/5/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ServiceLocationViewController: UIViewController,CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initMapView()
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    var serviceObject : ServiceModel?
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var confirmButton:UIButton?
    
    func initMapView() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    /**
     CLLocation delegate
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        //Update location to server
        //make new map after updated location
        let center = CLLocationCoordinate2D(latitude: Double((serviceObject?.latitude)!)!, longitude: Double((serviceObject?.longitude)!)!)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10)
        let mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: 64, width: self.view.frame.width, height:self.view.frame.height), camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = center
        marker.map = mapView
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location falure")
    }
    
    func searchLocationByAddress(address:String) {
        let parameter = ["address":address,"key":googleKey]
        
        APIManager.sharedInstance.getDataFromFullUrl(url: "https://maps.googleapis.com/maps/api/geocode/json", parameters: parameter, onCompletion: { response in
            print(response)
        })
    }

}
