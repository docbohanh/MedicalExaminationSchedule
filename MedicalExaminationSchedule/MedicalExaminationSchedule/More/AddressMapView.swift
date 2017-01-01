//
//  AddressMapView.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 1/1/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class AddressMapView: UIView,CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var confirmButton:UIButton?
    
    func initMapView() {
        locationManager.delegate = self
    }
    /**
     CLLocation delegate
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        //Update location to server
        //make new map after updated location
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10)
        let mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: 0, width: self.frame.width, height:self.frame.height), camera: camera)
        mapView.isMyLocationEnabled = true
        self.addSubview(mapView)
        
        confirmButton = UIButton.init(type: UIButtonType.custom)
        confirmButton?.frame = CGRect.init(x: 30, y: self.frame.size.height - 100, width: self.frame.size.width - 60, height: 40)
        confirmButton?.layer.cornerRadius = (confirmButton?
            .frame.height)!/2
        confirmButton?.setTitleColor(UIColor.white, for: UIControlState.normal)
        confirmButton?.setTitle("XÁC NHẬN", for:  UIControlState.normal)
        confirmButton?.backgroundColor = UIColor(red: 24/255, green: 230/255, blue: 226/255, alpha: 1.0)
        mapView.addSubview(confirmButton!)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = center
        marker.map = mapView
        locationManager.stopUpdatingLocation()
    }
    
    func searchLocationByAddress(address:String) {
        let parameter = ["address":address,"key":googleKey]
        
        APIManager.sharedInstance.getDataFromFullUrl(url: "https://maps.googleapis.com/maps/api/geocode/json", parameters: parameter, onCompletion: { response in
            print(response)
        })
    }
}
