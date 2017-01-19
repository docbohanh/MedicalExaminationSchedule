//
//  DrugStoreViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 1/17/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps

class DrugStoreViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    //    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var searchMapView = UIView()
    
    var serviceHospitalDictionary = [String : [ServiceModel]]()
    
    var serviceHospitalArray = [ServiceModel]()
    var currentArray = [ServiceModel]()
    var filterArray = [ServiceModel]()
    var numOfSectionFilter: Int = 0
    var serviceFilterDictionary = [String : [ServiceModel]]()
    
    var pageIndexHospital = 0
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
        self.getServiceHospital(page_index: pageIndexHospital, type: "nt")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // PullToRefresh
        weak var weakSelf = self
        refreshControl = ProjectCommon.addPullRefreshControl(tableView, actionHandler: {
            self.pullToRefresh()
        })
    }
    
    func pullToRefresh() -> Void {
        self.pageIndexHospital = 0
        if self.serviceHospitalArray.count > 0 {
            self.serviceHospitalArray.removeAll()
        }
        self.tableView.reloadData()
        self.getServiceHospital(page_index: self.pageIndexHospital, type: "nt")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchMapView = UIView.init(frame: CGRect.init(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height:  tableView.frame.size.height + 49))
        searchMapView.isHidden = true
        self.view.addSubview(searchMapView)
        self.getCurrentLocation()
        self.tabBarController?.tabBar.isHidden = false
        
    }
    override func viewDidLayoutSubviews() {
        
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            
            mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: searchView.frame.origin.y + searchView.frame.height, width: tableView.frame.size.width, height:view.frame.size.height - searchView.frame.origin.y - searchView.frame.height), camera: camera)
            mapView?.delegate = self
            mapView?.isMyLocationEnabled = true
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
        self.performSegue(withIdentifier: "PushToDrugStoreDetail", sender: self)
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
    
    func resetSearchBar() {
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return serviceHospitalDictionary.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keysArray = serviceHospitalDictionary.keys.sorted()
        let serviceArray = serviceHospitalDictionary[keysArray[section]]
        return serviceArray != nil ? (serviceArray?.count)! : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.first as! headerView
        let keysArray = serviceHospitalDictionary.keys.sorted()
        if keysArray.count > section {
            headerView.headerLabel.text = keysArray[section]
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAddressTableViewCell", for: indexPath) as! DoctorAddressTableViewCell
        var object : ServiceModel?
        let serviceKeyArray = serviceHospitalDictionary.keys.sorted()
        if serviceKeyArray.count > indexPath.section {
            let serviceArray = serviceHospitalDictionary[serviceKeyArray[indexPath.section]]
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
                        self.serviceHospitalArray += tempArray
                        self.serviceHospitalDictionary.removeAll()
                        self.serviceHospitalDictionary = self.groupService(originArray: self.serviceHospitalArray)
                        self.initMapview(locations: self.serviceHospitalArray)
                        self.currentArray = self.serviceHospitalArray
                        self.locationManager.startUpdatingLocation()
                        DispatchQueue.global().async {
                            self.loadMoreService(page_index: self.pageIndexHospital, type: "nt")
                        }
                        
                        self.tableView.reloadData()
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
                        self.pageIndexHospital = self.pageIndexHospital + 1
                        self.serviceHospitalArray += tempArray
                        self.serviceHospitalDictionary.removeAll()
                        self.serviceHospitalDictionary = self.groupService(originArray: self.serviceHospitalArray)
                        self.initMapview(locations: self.serviceHospitalArray)
                        self.currentArray = self.serviceHospitalArray
                        self.locationManager.startUpdatingLocation()
                        if self.queryString == "" {
                            DispatchQueue.global().async {
                                self.loadMoreService(page_index: self.pageIndexHospital, type: "nt")
                            }
                        }
                        
                    }else {
                        self.tableView.reloadData()
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
        if segue.identifier == "PushToDrugStoreDetail" {
            let detailVC = segue.destination as! DoctorManagementViewController
            detailVC.serviceObject = currentService
        }
    }
    
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
