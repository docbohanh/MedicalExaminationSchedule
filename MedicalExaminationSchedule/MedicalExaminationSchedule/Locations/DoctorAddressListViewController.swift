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
        selectedTab = 0
        tabLineView.center = CGPoint.init(x: hospitalButton.center.x, y: tabLineView.center.y)
        if serviceHospitalArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "bv")
        }
        self.resetSearchBar()
    }
    
    @IBAction func tappedClinicSearch(_ sender: UIButton) {
        selectedTab = 1
        tabLineView.center = CGPoint.init(x: clinicButton.center.x, y: tabLineView.center.y)
        if serviceClinicArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "pk")
        }
        self.resetSearchBar()
    }
    
    @IBAction func tappedDrugStoreSearch(_ sender: UIButton) {
        selectedTab = 2
        tabLineView.center = CGPoint.init(x: drugStore.center.x, y: tabLineView.center.y)
        if serviceDrugStoreArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "nt")
        }
        self.resetSearchBar()
    }
    
    @IBAction func tappedDoctorSearch(_ sender: UIButton) {
        selectedTab = 3
        tabLineView.center = CGPoint.init(x: doctorButton.center.x, y: tabLineView.center.y)
        if serviceDoctorArray.count == 0 {
            self.getServiceHospital(page_index: 0, type: "bs")
        }
        self.resetSearchBar()
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
        
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: SERVICE_USER, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
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
                        break
                    case 1:
                        self.serviceClinicArray += tempArray
                        break
                    case 2:
                        self.serviceDrugStoreArray += tempArray
                        break
                    default:
                        self.serviceDoctorArray += tempArray
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
