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
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var hospitalButton: UIButton!
    @IBOutlet weak var drugStore: UIButton!
    @IBOutlet weak var doctorButton: UIButton!
    @IBOutlet weak var clinicButton: UIButton!
    @IBOutlet weak var tabLineView: UIView!
    @IBOutlet weak var doctorAddressTableView: UITableView!
//    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var searchMapView = UIView()
    
    var serviceHospitalDictionary = [String : [ServiceModel]]()
    var serviceClinicDictionary = [String : [ServiceModel]]()
    var serviceDrugStoreDictionary = [String : [ServiceModel]]()
    var serviceDoctorDictionary = [String : [ServiceModel]]()
    
    var serviceHospitalArray = [ServiceModel]()
    var serviceClinicArray = [ServiceModel]()
    var serviceDrugStoreArray = [ServiceModel]()
    var serviceDoctorArray = [ServiceModel]()
    var currentArray = [ServiceModel]()
    var filterArray = [ServiceModel]()
    var numOfSectionFilter: Int = 0
    var serviceFilterDictionary = [String : [ServiceModel]]()
    
    var pageIndexHospital = 0
    var pageIndexClinic = 0
    var pageIndexDrugStore = 0
    var pageIndexDoctor = 0
    var currentMarker = GMSMarker()
    
    var selectedTab = 0
    var currentService : ServiceModel?
    var mapView : GMSMapView?
    var rectangle = GMSPolyline()
    var refreshControl : UIRefreshControl?
    var queryString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.getServiceHospital(page_index: pageIndexHospital, type: "bv")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // PullToRefresh
        weak var weakSelf = self
        refreshControl = ProjectCommon.addPullRefreshControl(doctorAddressTableView, actionHandler: {
            self.pullToRefresh()
        })
    }
    
    func pullToRefresh() -> Void {
        switch self.selectedTab {
        case 0:
            self.pageIndexHospital = 0
            if self.serviceHospitalArray.count > 0 {
                self.serviceHospitalArray.removeAll()
            }
            self.doctorAddressTableView.reloadData()
            self.getServiceHospital(page_index: self.pageIndexHospital, type: "bv")
            break
        case 1:
            self.pageIndexClinic = 0
            if self.serviceClinicArray.count > 0 {
                self.serviceClinicArray.removeAll()
            }
            self.doctorAddressTableView.reloadData()
            self.getServiceHospital(page_index: self.pageIndexClinic, type: "pk")
            break
        case 2:
            self.pageIndexDrugStore = 0
            if self.serviceDrugStoreArray.count > 0 {
                self.serviceDrugStoreArray.removeAll()
            }
            self.doctorAddressTableView.reloadData()
            self.getServiceHospital(page_index: self.pageIndexDrugStore, type: "nt")
            break
        case 3:
            self.pageIndexDoctor = 0
            if self.serviceDoctorArray.count > 0 {
                self.serviceDoctorArray.removeAll()
            }
            self.doctorAddressTableView.reloadData()
            self.getServiceHospital(page_index: self.pageIndexDoctor, type: "bs")
            break
        default:
            break
        }
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
            let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 12)

            mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: segmentView.frame.origin.y + segmentView.frame.height, width: doctorAddressTableView.frame.size.width, height:view.frame.size.height - segmentView.frame.origin.y - segmentView.frame.height), camera: camera)
            mapView?.delegate = self
            mapView?.isMyLocationEnabled = true
//            let getPositionButton = UIButton.init(type: UIButtonType.custom)
//            getPositionButton.frame = CGRect.init(x: 30, y: (mapView?.frame.size.height)! - 100, width: self.view.frame.size.width - 60, height: 40)
//            getPositionButton.layer.cornerRadius = getPositionButton.frame.height/2
//            getPositionButton.setTitleColor(UIColor.white, for: UIControlState.normal)
//            getPositionButton.setTitle("LẤY PHƯƠNG HƯỚNG", for:  UIControlState.normal)
//            getPositionButton.backgroundColor = UIColor(red: 24/255, green: 230/255, blue: 226/255, alpha: 1.0)
//            mapView?.addSubview(getPositionButton)
            
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
        for index in 0..<locations.count {
            let location : ServiceModel = locations[index]
            
            let lat = Double(location.latitude!)! as CLLocationDegrees
            let lng = Double(location.longitude!)! as CLLocationDegrees
            let marker = GMSMarker()
            
            let center = CLLocationCoordinate2D(latitude:lat, longitude:lng)
            marker.position = center
            marker.icon = UIImage(named: "ic_location")
//            if marker.position.latitude == currentMarker.position.latitude && marker.position.longitude == currentMarker.position.longitude {
//                mapView?.selectedMarker = marker
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.isFlat = true
                marker.zIndex = Int32(index)
                marker.title = location.name
                marker.snippet = location.address
                

//            }
            marker.map = mapView
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location falure")
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("tapped in map")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        print("tapped my location map view")
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        currentMarker = marker

        rectangle.map = nil
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2DMake(currentLocation.coordinate.latitude,currentLocation.coordinate.longitude))
        
        APIManager.sharedInstance.getDirectionUrl(url: "https://maps.googleapis.com/maps/api/directions/json", originLat: String(currentLocation.coordinate.latitude), originLng: String(currentLocation.coordinate.longitude), destinationLat: String(marker.position.latitude), destinationLng: String(marker.position.longitude), key: "AIzaSyBixzG1uPZdLzZO9WoH2_3w-V7lVSeXBRE", onCompletion:{ response in
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
                            path.add(CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude))
                            self.rectangle = GMSPolyline(path: path)
                            self.rectangle.strokeWidth = 4.0
                            self.rectangle.strokeColor = UIColor.init(red: 25/255, green: 114/255, blue: 196/266, alpha: 1)
                            self.rectangle.map = self.mapView
                        }
                    }
                }
            }
            print(response)
        })
        return false
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        currentService = currentArray[Int(marker.zIndex)]
        self.performSegue(withIdentifier: "PushToServiceDetail", sender: self)
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
        if selectedTab != 0 {
            selectedTab = 0
            self.reloadSelectedButton()
            tabLineView.center = CGPoint.init(x: hospitalButton.center.x, y: tabLineView.center.y)
        }
//        if serviceHospitalArray.count == 0 {
//            self.getServiceHospital(page_index: 0, type: "bv")
//        } else {
//            self.initMapview(locations: serviceHospitalArray)
//        }
//        self.resetSearchBar()
    }
    
    @IBAction func tappedClinicSearch(_ sender: UIButton) {
        if selectedTab != 1 {
            selectedTab = 1
            tabLineView.center = CGPoint.init(x: clinicButton.center.x, y: tabLineView.center.y)
            self.reloadSelectedButton()
        }
        
//        if serviceClinicArray.count == 0 {
//            self.getServiceHospital(page_index: 0, type: "pk")
//        } else {
//            self.initMapview(locations: serviceClinicArray)
//        }
        
//        self.resetSearchBar()
    }
    
    @IBAction func tappedDrugStoreSearch(_ sender: UIButton) {
        if selectedTab != 2 {
            selectedTab = 2
            tabLineView.center = CGPoint.init(x: drugStore.center.x, y: tabLineView.center.y)
            self.reloadSelectedButton()
        }
        
//        if serviceDrugStoreArray.count == 0 {
//            self.getServiceHospital(page_index: 0, type: "nt")
//        } else {
//            self.initMapview(locations: serviceDrugStoreArray)
//        }
        
//        self.resetSearchBar()
    }
    
    @IBAction func tappedDoctorSearch(_ sender: UIButton) {
        if selectedTab != 3 {
            selectedTab = 3
            tabLineView.center = CGPoint.init(x: doctorButton.center.x, y: tabLineView.center.y)
            self.reloadSelectedButton()
        }
        
//        if serviceDoctorArray.count == 0 {
//            self.getServiceHospital(page_index: 0, type: "bs")
//        } else {
//            self.initMapview(locations: serviceDoctorArray)
//        }
        
//        self.resetSearchBar()
    }
    
    func reloadSelectedButton() -> Void {
        self.pullToRefresh()
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
        doctorAddressTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch selectedTab {
        case 0:
            return serviceHospitalDictionary.keys.count
        case 1:
            return serviceClinicDictionary.keys.count
        case 2:
            return serviceDrugStoreDictionary.keys.count
        default:
            return serviceDoctorDictionary.keys.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedTab {
        case 0:
            let keysArray = serviceHospitalDictionary.keys.sorted()
            let serviceArray = serviceHospitalDictionary[keysArray[section]]
            return serviceArray != nil ? (serviceArray?.count)! : 0
        case 1:
            let keysArray = serviceClinicDictionary.keys.sorted()
            let serviceArray = serviceClinicDictionary[keysArray[section]]
            return serviceArray != nil ? (serviceArray?.count)! : 0
        case 2:
            let keysArray = serviceDrugStoreDictionary.keys.sorted()
            let serviceArray = serviceDrugStoreDictionary[keysArray[section]]
            return serviceArray != nil ? (serviceArray?.count)! : 0
        default:
            let keysArray = serviceDoctorDictionary.keys.sorted()
            let serviceArray = serviceDoctorDictionary[keysArray[section]]
            return serviceArray != nil ? (serviceArray?.count)! : 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.first as! headerView
        
        switch selectedTab {
        case 0:
             let keysArray = serviceHospitalDictionary.keys.sorted()
             if keysArray.count > section {
                headerView.headerLabel.text = keysArray[section]
             }
                break
        case 1:
            let keysArray = serviceClinicDictionary.keys.sorted()
            if keysArray.count > section {
                headerView.headerLabel.text = keysArray[section]
            }
        case 2:
            let keysArray = serviceDrugStoreDictionary.keys.sorted()
            if keysArray.count > section {
                headerView.headerLabel.text = keysArray[section]
            }        default:
            let keysArray = serviceDoctorDictionary.keys.sorted()
            headerView.headerLabel.text = keysArray[section]
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAddressTableViewCell", for: indexPath) as! DoctorAddressTableViewCell
        var object : ServiceModel?
        switch selectedTab {
        case 0:
            let serviceKeyArray = serviceHospitalDictionary.keys.sorted()
            if serviceKeyArray.count > indexPath.section {
                let serviceArray = serviceHospitalDictionary[serviceKeyArray[indexPath.section]]
                if (serviceArray?.count)! > indexPath.row {
                    object = serviceArray?[indexPath.row]
                }
            }
            break
        case 1:
            let serviceKeyArray = serviceClinicDictionary.keys.sorted()
            let serviceArray = serviceClinicDictionary[serviceKeyArray[indexPath.section]]
            if (serviceArray?.count)! > indexPath.row {
                object = serviceArray?[indexPath.row]
            }
            break
        case 2:
            let serviceKeyArray = serviceDrugStoreDictionary.keys.sorted()
            let serviceArray = serviceDrugStoreDictionary[serviceKeyArray[indexPath.section]]
            if (serviceArray?.count)! > indexPath.row {
                object = serviceArray?[indexPath.row]
            }
            break
        default:
            let serviceKeyArray = serviceDoctorDictionary.keys.sorted()
            let serviceArray = serviceDoctorDictionary[serviceKeyArray[indexPath.section]]
            if (serviceArray?.count)! > indexPath.row {
                object = serviceArray?[indexPath.row]
            }
        }
        if object != nil {
            cell.setupCell(object: object!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DoctorAddressTableViewCell
        currentService = cell.serviceDetail
        self.performSegue(withIdentifier: "PushToServiceDetail", sender: self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServiceHospital(page_index:Int, type:String) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["lat"] = UserDefaults.standard.object(forKey: "latitude") as? String ?? "21.0133267"
        dictParam["lng"] = UserDefaults.standard.object(forKey: "longitude") as? String ?? "105.7809231"
        dictParam["type"] = type
        dictParam["query"] = queryString
        dictParam["page_index"] = String.init(format: "%d", page_index)
        DispatchQueue.main.async {
            Lib.showLoadingViewOn2(self.view, withAlert: "Loading ...")
        }
        APIManager.sharedInstance.getDataToURL(url: SERVICE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            ProjectCommon.stopAnimationRefresh()
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy  dịch vụ", buttonArray: ["Đóng"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    if listItem.count > 0 {
                        var tempArray = [ServiceModel]()
                        for i in 0..<listItem.count {
                            let item = listItem[i] as! [String:AnyObject]
                            let newsObject = ServiceModel.init(dict: item)
                            tempArray += [newsObject]
                        }
                        switch self.selectedTab {
                        case 0:
                            self.serviceHospitalDictionary.removeAll()
                            self.serviceHospitalDictionary = self.groupService(originArray: tempArray)
                            self.serviceHospitalArray += tempArray
                            self.initMapview(locations: self.serviceHospitalArray)
                            self.currentArray = self.serviceHospitalArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexHospital, type: "bv")
                            }
                            break
                        case 1:
                            self.serviceClinicDictionary.removeAll()
                            self.serviceClinicDictionary = self.groupService(originArray: tempArray)
                            self.serviceClinicDictionary.removeAll()
                            self.serviceClinicDictionary = self.groupService(originArray: tempArray)
                            self.serviceClinicArray += tempArray
                            self.initMapview(locations: self.serviceClinicArray)
                            self.currentArray = self.serviceClinicArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexClinic, type: "pk")
                            }
                            break
                        case 2:
                            self.serviceDrugStoreDictionary.removeAll()
                            self.serviceDrugStoreDictionary = self.groupService(originArray: tempArray)
                            self.serviceDrugStoreArray += tempArray
                            self.initMapview(locations: self.serviceDrugStoreArray)
                            self.currentArray = self.serviceDrugStoreArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexDrugStore, type: "nt")
                            }
                            break
                        default:
                            self.serviceDoctorDictionary.removeAll()
                            self.serviceDoctorDictionary = self.groupService(originArray: tempArray)
                            self.serviceDoctorArray += tempArray
                            self.initMapview(locations: self.serviceDoctorArray)
                            self.currentArray = self.serviceDoctorArray
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexDoctor, type: "bs")
                            }
                            self.locationManager.startUpdatingLocation()
                            break
                        }
                        self.doctorAddressTableView.reloadData()
                    }
                    
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy  dịch vụ", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func loadMoreService(page_index:Int, type:String) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["lat"] = UserDefaults.standard.object(forKey: "latitude") as? String ?? "21.0133267"
        dictParam["lng"] = UserDefaults.standard.object(forKey: "longitude") as? String ?? "105.7809231"
        dictParam["type"] = type
        dictParam["query"] = queryString
        dictParam["page_index"] = String.init(format: "%d", page_index+1)
        DispatchQueue.main.async {
//            Lib.showLoadingViewOn2(self.view, withAlert: "Loading ...")
        }
        APIManager.sharedInstance.getDataToURL(url: SERVICE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
//                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy  dịch vụ", buttonArray: ["Đóng"], onCompletion: { (index) in
//                    
//                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    if listItem.count > 0 {
                        var tempArray = [ServiceModel]()
                        for i in 0..<listItem.count {
                            let item = listItem[i] as! [String:AnyObject]
                            let newsObject = ServiceModel.init(dict: item)
                            tempArray += [newsObject]
                        }
                        switch self.selectedTab {
                        case 0:
                            self.serviceHospitalDictionary.removeAll()

                            self.serviceHospitalDictionary = self.groupService(originArray: tempArray)
                            self.pageIndexHospital = self.pageIndexHospital + 1
                            self.serviceHospitalArray += tempArray
                            self.initMapview(locations: self.serviceHospitalArray)
                            self.currentArray = self.serviceHospitalArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexHospital, type: "bv")
                            }
                            break
                        case 1:
                            self.serviceClinicDictionary.removeAll()
                            self.serviceClinicDictionary = self.groupService(originArray: tempArray)
                            self.pageIndexClinic = self.pageIndexClinic + 1
                            self.serviceClinicArray += tempArray
                            self.initMapview(locations: self.serviceClinicArray)
                            self.currentArray = self.serviceClinicArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexClinic, type: "pk")
                            }
                            break
                        case 2:
                            self.serviceDrugStoreDictionary.removeAll()
                            self.serviceDrugStoreDictionary = self.groupService(originArray: tempArray)
                            self.pageIndexDrugStore = self.pageIndexDrugStore + 1
                            self.serviceDrugStoreArray += tempArray
                            self.initMapview(locations: self.serviceDrugStoreArray)
                            self.currentArray = self.serviceDrugStoreArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexDrugStore, type: "nt")
                            }
                            break
                        default:
                            self.serviceDoctorDictionary.removeAll()
                            self.serviceDoctorDictionary = self.groupService(originArray: tempArray)
                            self.pageIndexDoctor = self.pageIndexDoctor + 1
                            self.serviceDoctorArray += tempArray
                            self.initMapview(locations: self.serviceDoctorArray)
                            self.currentArray = self.serviceDoctorArray
                            self.locationManager.startUpdatingLocation()
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexDoctor, type: "bs")
                            }
                            break
                        }
                    }else {
                        self.doctorAddressTableView.reloadData()
                    }
                    
                }else {
//                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy  dịch vụ", buttonArray: ["Đóng"], onCompletion: { (index) in
//                        
//                    })
                }
            }
        })
    }


    func groupService(originArray:[ServiceModel]) -> [String:[ServiceModel]] {
        var currentServiceDictionary = [String:[ServiceModel]]()
        for object in originArray {
            if object.field != nil {
                if currentServiceDictionary[object.field!] != nil {
                    var serviceArray:[ServiceModel] = currentServiceDictionary[object.field!]!
                    serviceArray.append(object)
                    currentServiceDictionary[object.field!] = serviceArray
                } else {
                    currentServiceDictionary[object.field!] = [object]
                }
            }
        }
        return currentServiceDictionary
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
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let searchString = searchText.lowercased()
//        var array = [ServiceModel]()
//        switch self.selectedTab {
//        case 0:
//            array = self.serviceHospitalArray
//            break
//        case 1:
//            array = self.serviceClinicArray
//            break
//        case 2:
//            array = self.serviceDrugStoreArray
//            break
//        default:
//            array = self.serviceDoctorArray
//            break
//        }
//        filterArray.removeAll()
//        filterArray = array.filter({ (object : ServiceModel) -> Bool in
//            let categoryMatch = (object.name?.lowercased().contains(searchString))! || (object.address?.lowercased().contains(searchString))!
//            return categoryMatch
//        })
//        if(filterArray.count == 0 || searchString == ""){
//            searchActive = false;
//        } else {
//            serviceFilterDictionary.removeAll()
//            serviceFilterDictionary = self.groupService(originArray: filterArray)
//            searchActive = true;
//        }
//        doctorAddressTableView.reloadData()
//    }
    
    @IBAction func tapped_searchButton(_ sender: Any) {
        queryString = searchTextField.text!
        self.pullToRefresh()
    }
    /* --------- TEXT FIELD DELEGATE --------------*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        queryString = textField.text!
        self.pullToRefresh()
    }
}
