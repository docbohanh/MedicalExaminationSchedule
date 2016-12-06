//
//  DoctorAddressListViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class DoctorAddressListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate {
    @IBOutlet weak var searchView: UIView!

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var hospitalButton: UIButton!
    
    @IBOutlet weak var drugStore: UIButton!
    
    @IBOutlet weak var doctorButton: UIButton!
    
    @IBOutlet weak var clinicButton: UIButton!
    
    @IBOutlet weak var tabLineView: UIView!
    @IBOutlet weak var doctorAddressTableView: UITableView!
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var searchMapView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        searchMapView = UIView.init(frame: CGRect.init(x: doctorAddressTableView.frame.origin.x, y: doctorAddressTableView.frame.origin.y, width: doctorAddressTableView.frame.size.width, height:  doctorAddressTableView.frame.size.height + 49))
        searchMapView.isHidden = true
        self.view.addSubview(searchMapView)
        self.getCurrentLocation()
    }
    override func viewDidLayoutSubviews() {
        
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
        let mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: 0, width: doctorAddressTableView.frame.size.width, height:  doctorAddressTableView.frame.size.height + 49), camera: camera)
        mapView.isMyLocationEnabled = true
        searchMapView.addSubview(mapView)
        
        let getPositionButton = UIButton.init(type: UIButtonType.custom)
        getPositionButton.frame = CGRect.init(x: 30, y: searchMapView.frame.size.height - 280, width: self.view.frame.size.width - 60, height: 40)
        getPositionButton.layer.cornerRadius = getPositionButton.frame.height/2
        getPositionButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        getPositionButton.setTitle("LẤY PHƯƠNG HƯỚNG", for:  UIControlState.normal)
        getPositionButton.backgroundColor = UIColor(red: 24/255, green: 230/255, blue: 226/255, alpha: 1.0)
        searchMapView.addSubview(getPositionButton)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = center
        marker.map = mapView
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location falure")
    }
    
    func getPosition() {
        
    }
    func getCurrentLocation() {
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
    
    @IBAction func tappedSearch(_ sender: UIButton) {
    }
    
    @IBAction func tappedSearchFollowMap(_ sender: UIButton) {
        if sender.isSelected {
            searchMapView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
        } else {
            self.tabBarController?.tabBar.isHidden = true
            searchMapView.isHidden = false
        }
        sender.isSelected = !sender.isSelected
    }
    @IBAction func tappedHospitalSearch(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: hospitalButton.center.x, y: tabLineView.center.y)
    }
    
    @IBAction func tappedDrugStoreSearch(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: drugStore.center.x, y: tabLineView.center.y)
    }
    
    @IBAction func tappedDoctorSearch(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: doctorButton.center.x, y: tabLineView.center.y)
    }
    
    @IBAction func tappedClinicSearch(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: clinicButton.center.x, y: tabLineView.center.y)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.first as! headerView
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAddressTableViewCell", for: indexPath) as! DoctorAddressTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
