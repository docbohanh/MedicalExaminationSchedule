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

class DoctorAddressListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var hospitalButton: UIButton!
    @IBOutlet weak var drugStore: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var clinicButton: UIButton!
    @IBOutlet weak var tabLineView: UIView!
    @IBOutlet weak var doctorAddressTableView: UITableView!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var searchMapView = UIView()
    
    var serviceHospitalArray = [ServiceModel]()
    var serviceClinicArray = [ServiceModel]()
    var serviceDrugStoreArray = [ServiceModel]()
    var serviceDoctorArray = [ServiceModel]()
    var filterArray = [ServiceModel]()
    
    var pageIndexHospital = 0
    var pageIndexClinic = 0
    var pageIndexDrugStore = 0
    var pageIndexDoctor = 0
    
    var selectedTab = 0
    var currentService : ServiceModel?
    var searchActive : Bool = false
    var mapView : GMSMapView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getServiceHospital(page_index: pageIndexHospital, type: "bv")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        searchMapView = UIView.init(frame: CGRect.init(x: doctorAddressTableView.frame.origin.x, y: doctorAddressTableView.frame.origin.y, width: doctorAddressTableView.frame.size.width, height:  doctorAddressTableView.frame.size.height + 49))
        searchMapView.isHidden = true
        self.view.addSubview(searchMapView)
        self.getCurrentLocation()
        self.tabBarController?.tabBar.isHidden = false

    }
    override func viewDidLayoutSubviews() {
        
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    /**
     CLLocation delegate
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        //Update location to server
        //make new map after updated location
        if mapView == nil {
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 14)

            mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: segmentView.frame.origin.y + segmentView.frame.height, width: doctorAddressTableView.frame.size.width, height:view.frame.size.height - segmentView.frame.origin.y - segmentView.frame.height), camera: camera)
            mapView?.delegate = self
            mapView?.isMyLocationEnabled = true
            let getPositionButton = UIButton.init(type: UIButtonType.custom)
            getPositionButton.frame = CGRect.init(x: 30, y: (mapView?.frame.size.height)! - 100, width: self.view.frame.size.width - 60, height: 40)
            getPositionButton.layer.cornerRadius = getPositionButton.frame.height/2
            getPositionButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            getPositionButton.setTitle("LẤY PHƯƠNG HƯỚNG", for:  UIControlState.normal)
            getPositionButton.backgroundColor = UIColor(red: 24/255, green: 230/255, blue: 226/255, alpha: 1.0)
            mapView?.addSubview(getPositionButton)
            
            // Creates a marker in the center of the map.

        }
        locationManager.stopUpdatingLocation()
    }
    
    func initMapview(locations : [ServiceModel]) {
        mapView?.clear()
        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        let marker = GMSMarker()
        marker.position = center
        marker.map = mapView
        marker.icon = UIImage(named: "ic_location_active")
        for location : ServiceModel in locations {
            let lat = Double(location.latitude!)! as CLLocationDegrees
            let lng = Double(location.longitude!)! as CLLocationDegrees
            let marker = GMSMarker()
            let center = CLLocationCoordinate2D(latitude:lat, longitude:lng)
            marker.position = center
            marker.title = location.name
            marker.snippet = location.address
            marker.icon = UIImage(named: "ic_location")
            marker.map = mapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location falure")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        mapView.clear()
        locationManager.startUpdatingLocation()
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude))
//        path.add(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
        
        APIManager.sharedInstance.getDirectionUrl(url: "https://maps.googleapis.com/maps/api/directions/json", originLat: String(currentLocation.coordinate.latitude), originLng: String(currentLocation.coordinate.longitude), destinationLat: String(coordinate.latitude), destinationLng: String(coordinate.longitude), key: "AIzaSyBixzG1uPZdLzZO9WoH2_3w-V7lVSeXBRE", onCompletion:{ response in
            if response.result.error == nil && response.result.isSuccess {
                let results = response.result
                if results != nil {
                    let value = results.value as! [String : AnyObject]
                    if value != nil {
                        let routes = value["routes"] as! [[String:AnyObject]]
                        if routes.count > 0 {
                            let firstRoute = routes.first
                            let legs = firstRoute?["legs"] as! [[String:AnyObject]]
                            let steps:[[String:AnyObject]] = legs.first!["steps"] as! [[String : AnyObject]]
                            for location in steps {
                                let start_location = location["start_location"]
                                let lat = start_location!["lat"] as! Double
                                let lng = start_location!["lng"] as! Double
                                if lat != nil && lng != nil {
                                    path.add(CLLocationCoordinate2DMake(lat,lng))
                                }
                            }
                                path.add(CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude))
                            let rectangle = GMSPolyline(path: path)
                            rectangle.strokeWidth = 4.0
                            rectangle.strokeColor = UIColor.init(red: 25/255, green: 114/255, blue: 196/266, alpha: 1)
                            rectangle.map = self.mapView
                        }
                    }
                }
            }
            print(response)
        })
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        APIManager.sharedInstance.getDirectionUrl(url: "https://maps.googleapis.com/maps/api/directions/json", originLat: String(currentLocation.coordinate.latitude), originLng: String(currentLocation.coordinate.longitude), destinationLat: String(marker.position.longitude), destinationLng: String(marker.position.longitude), key: "AIzaSyBixzG1uPZdLzZO9WoH2_3w-V7lVSeXBRE", onCompletion:{ response in
            print(response)
        })
        
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
            mapView?.removeFromSuperview()
            self.tabBarController?.tabBar.isHidden = false
        } else {
            view.addSubview(mapView!)
            self.tabBarController?.tabBar.isHidden = true
        }
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func tappedHospitalSearch(_ sender: UIButton) {
        selectedTab = 0
        self.reloadSelectedButton()
        tabLineView.center = CGPoint.init(x: hospitalButton.center.x, y: tabLineView.center.y)
        if serviceHospitalArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "bv")
        } else {
            self.initMapview(locations: serviceHospitalArray)
        }
        self.resetSearchBar()
    }
    
    @IBAction func tappedClinicSearch(_ sender: UIButton) {
        selectedTab = 1
        self.reloadSelectedButton()
        tabLineView.center = CGPoint.init(x: clinicButton.center.x, y: tabLineView.center.y)
        if serviceClinicArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "pk")
        } else {
            self.initMapview(locations: serviceClinicArray)
        }
        self.resetSearchBar()
    }
    
    @IBAction func tappedDrugStoreSearch(_ sender: UIButton) {
        selectedTab = 2
        self.reloadSelectedButton()
        tabLineView.center = CGPoint.init(x: drugStore.center.x, y: tabLineView.center.y)
        if serviceDrugStoreArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "nt")
        } else {
            self.initMapview(locations: serviceDrugStoreArray)
        }
        self.resetSearchBar()
    }
    
    @IBAction func tappedDoctorSearch(_ sender: UIButton) {
        selectedTab = 3
        self.reloadSelectedButton()
        tabLineView.center = CGPoint.init(x: doctorButton.center.x, y: tabLineView.center.y)
        if serviceDoctorArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "bs")
        } else {
            self.initMapview(locations: serviceDoctorArray)
        }
        self.resetSearchBar()
    }
    
    func reloadSelectedButton() -> Void {
        
        hospitalButton.isSelected = false
        clinicButton.isSelected = false
        drugStore.isSelected = false
        doctorButton.isSelected = false
        switch selectedTab {
        case 0:
            hospitalButton.isSelected = true
            break
        case 1:
            clinicButton.isSelected = true
            break
        case 2:
            drugStore.isSelected = true
            break
        default:
            doctorButton.isSelected = true
            break
        }
    }
    
    func resetSearchBar() -> Void {
        locationSearchBar.text = ""
        searchActive = false
        doctorAddressTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterArray.count
        }else {
            switch selectedTab {
            case 0:
                return serviceHospitalArray.count
            case 1:
                return serviceClinicArray.count
            case 2:
                return serviceDrugStoreArray.count
            default:
                return serviceDoctorArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.first as! headerView
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAddressTableViewCell", for: indexPath) as! DoctorAddressTableViewCell
        var object : ServiceModel?
        if searchActive {
            object = filterArray[indexPath.row]
        }else {
            switch selectedTab {
            case 0:
                object = serviceHospitalArray[indexPath.row]
                break
            case 1:
                object = serviceClinicArray[indexPath.row]
                break
            case 2:
                object = serviceDrugStoreArray[indexPath.row]
                break
            default:
                object = serviceDoctorArray[indexPath.row]
            }
        }
        cell.setupCell(object: object!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            currentService = filterArray[indexPath.row]
        }else {
            switch selectedTab {
            case 0:
                currentService = serviceHospitalArray[indexPath.row]
                break
            case 1:
                currentService = serviceClinicArray[indexPath.row]
                break
            case 2:
                currentService = serviceDrugStoreArray[indexPath.row]
                break
            default:
                currentService = serviceDoctorArray[indexPath.row]
            }
        }
        
        self.performSegue(withIdentifier: "PushToServiceDetail", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServiceHospital(page_index:Int, type:String) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["lat"] = "21.0133267"
        dictParam["lng"] = "105.7809231"
        dictParam["type"] = type
        dictParam["query"] = ""
        dictParam["page_index"] = String.init(format: "%d", page_index)
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: SERVICE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]

                    let listItem = resultData["items"] as! [AnyObject]
                    var tempArray = [ServiceModel]()
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = ServiceModel.init(dict: item)
                       tempArray += [newsObject]
                    }
                    switch self.selectedTab {
                    case 0:
                        self.serviceHospitalArray += tempArray
                        self.initMapview(locations: self.serviceHospitalArray)
                        self.locationManager.startUpdatingLocation()
                        break
                    case 1:
                        self.serviceClinicArray += tempArray
                        self.initMapview(locations: self.serviceClinicArray)
                        self.locationManager.startUpdatingLocation()
                        break
                    case 2:
                        self.serviceDrugStoreArray += tempArray
                        self.initMapview(locations: self.serviceDrugStoreArray)
                        self.locationManager.startUpdatingLocation()
                        break
                    default:
                        self.serviceDoctorArray += tempArray
                        self.initMapview(locations: self.serviceDoctorArray)
                        self.locationManager.startUpdatingLocation()
                        break
                    }
                    
                    self.doctorAddressTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PushToServiceDetail" {
            let detailVC = segue.destination as! DoctorManagementViewController
            detailVC.serviceObject = currentService
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText.lowercased()
        var array = [ServiceModel]()
        switch self.selectedTab {
        case 0:
            array = self.serviceHospitalArray
            break
        case 1:
            array = self.serviceClinicArray
            break
        case 2:
            array = self.serviceDrugStoreArray
            break
        default:
            array = self.serviceDoctorArray
            break
        }
        filterArray = array.filter({ (object : ServiceModel) -> Bool in
            let categoryMatch = (object.name?.lowercased().contains(searchString))! || (object.address?.lowercased().contains(searchString))!
            return categoryMatch
        })
        if(filterArray.count == 0 && searchString == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        doctorAddressTableView.reloadData()
    }
   

}
