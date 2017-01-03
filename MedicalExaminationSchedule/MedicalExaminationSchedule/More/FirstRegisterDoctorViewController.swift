//
//  FirstRegisterDoctorViewController.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol FirstRegisterDoctorVCDelegate {
    func registerDoctorSuccess() -> Void
}

class FirstRegisterDoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileTableViewCellDelegate, ChangeAvatarViewDelegate, BottomViewCellDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var delegate : FirstRegisterDoctorVCDelegate?
    @IBOutlet weak var updateButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundPopUpView: UIView!
    var titleArray = [String]()
    var dataArray = [String]()
    var keyArray = [String]()
    
    var imageAvatar = UIImage()
    var isDoctor = false
    var isFirstRegisterDoctor = false
    var userProfile : UserModel?
    var changeBirthdayView :ChooseBirthdayView?
    var lat : Double = 20.997092
    var lng : Double = 105.8593733
    var locationManager = CLLocationManager()
    var currentLocation = CLLocation()
    var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view.

        titleArray += ["Họ Tên","Địa chỉ","Ngày sinh","Điện thoại","Nơi làm việc","Chuyên ngành", "Mã kích hoạt"]
        keyArray += ["name","address","birthday","phone","corporation","field","active_code"]
        dataArray += [(self.userProfile?.user_display_name)!, (self.userProfile?.home_address)!, (self.userProfile?.birthday)!, (self.userProfile?.phone)!, (self.userProfile?.work_address)!, (self.userProfile?.job)!,""]
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200.0;

        // register cell
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib.init(nibName: "TextFieldNormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldNormalTableViewCell")
        tableView.register(UINib.init(nibName: "BottomButtonTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "BottomButtonTableViewCell")
        self.createPopup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            updateButtonBottomConstraint.constant = keyboardHeight
        }
    }
    
    func keyboardWillHidden(notification:NSNotification) {
        updateButtonBottomConstraint.constant = 0
    }
    
    func createPopup() -> Void {
        let popupView = UINib(nibName: "ChangeAvatarView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! ChangeAvatarView
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 5.0
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.delegate = self
        backgroundPopUpView.addSubview(popupView)
        
        let views = ["popupView": popupView,
                     "backgroundPopUpView": backgroundPopUpView]
        let width = view.frame.size.width - 30
        
        let dictMetric = ["widthPopup" : width]
        
        // 2
        var allConstraints = [NSLayoutConstraint]()
        
        // 3
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundPopUpView]-(<=1)-[popupView(220)]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += verticalConstraints
        // 4
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[backgroundPopUpView]-(<=1)-[popupView(widthPopup)]",
            options: [.alignAllCenterY],
            metrics: dictMetric,
            views: views)
        allConstraints += horizontalConstraints
        
        backgroundPopUpView.addConstraints(allConstraints)
        backgroundPopUpView.isHidden = true
        
        changeBirthdayView = UINib(nibName: "ChooseBirthdayView", bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as? ChooseBirthdayView
        changeBirthdayView?.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        changeBirthdayView?.setupView(clickButton: { (button) in
            if (button.tag == 0) {
                // hidden view
                self.changeBirthdayView?.isHidden = true
            }else {
                // save birthday
                self.changeBirthdayView?.isHidden = true
                self.dataArray[2] = ProjectCommon.convertDateToString(date: (self.changeBirthdayView?.birthdayDatePicker.date)!)
                self.tableView.reloadRows(at: [IndexPath.init(row: 3, section: 0)], with: UITableViewRowAnimation.none)
            }
        })
        view .addSubview(changeBirthdayView!)
        changeBirthdayView?.isHidden = true
    }

    
    /* ========  TABLE VIEW =========== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.delegate = self
            cell.avatarImageView.image = imageAvatar
            return cell
        case (titleArray.count+1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "BottomButtonTableViewCell", for: indexPath) as! BottomButtonTableViewCell
            cell.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldNormalTableViewCell", for: indexPath) as! TextFieldNormalTableViewCell
            cell.titleLabel.text = titleArray[indexPath.row - 1]
            cell.cellTextField.delegate = self
            cell.cellTextField.text = dataArray[indexPath.row - 1]
            cell.cellTextField.tag = indexPath.row - 1
            let key = keyArray[indexPath.row - 1]
            if (key == "birthday") {
                cell.cellTextField.isEnabled = false
            } else {
                cell.cellTextField.isEnabled = true
                if (key == "phone") {
                    cell.cellTextField.keyboardType = UIKeyboardType.numberPad
                } else {
                    cell.cellTextField.keyboardType = UIKeyboardType.default
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 || indexPath.row == titleArray.count + 1 {
            return
        }
        let key = keyArray[indexPath.row - 1]
        if (key == "birthday") {
            changeBirthdayView?.isHidden = false
            changeBirthdayView?.birthdayDatePicker.date = ProjectCommon.convertStringDate(string: dataArray[indexPath.row - 1])
        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    /* =========== TEXT FIELD ========*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dataArray[textField.tag] = textField.text!
        if keyArray[textField.tag] == "corporation" {
            // tìm kiểm để ra lat long
            if (textField.text?.characters.count)! > 0 {
                self.searchLocationByAddress(address: textField.text!, onCompletion: {response in
                    if response.result != nil {
                        
                        let valueObject = response.result.value
                        if valueObject != nil {
                            let value = response.result.value as! [String : AnyObject]
                            let results = value["results"] as! [AnyObject]
                            if results != nil {
                                let geometry = results.first?["geometry"]
                                if geometry != nil{
                                    let location = geometry as? [String:AnyObject]
                                    if location != nil {
                                        let subLocation = location?["location"] as? [String:AnyObject]
                                        if subLocation != nil {
                                            self.lat = subLocation?["lat"] as! Double
                                            self.lng = subLocation?["lng"] as! Double
                                            self.initMapView()
                                        } else {
                                            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể xác định địa điểm này trên bản đồ", buttonArray: ["Đóng"], onCompletion: {_ in
                                            })
                                        }

                                    } else {
                                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể xác định địa điểm này trên bản đồ", buttonArray: ["Đóng"], onCompletion: {_ in
                                        })
                                    }
                                } else {
                                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể xác định địa điểm này trên bản đồ", buttonArray: ["Đóng"], onCompletion: {_ in
                                    })
                                }
                                
                            } else {
                                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể xác định địa điểm này trên bản đồ", buttonArray: ["Đóng"], onCompletion: {_ in
                                })
                            }
                        } else {
                            ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể xác định địa điểm này trên bản đồ", buttonArray: ["Đóng"], onCompletion: {_ in
                            })
                        }
                    } else {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể xác định địa điểm này trên bản đồ", buttonArray: ["Đóng"], onCompletion: {_ in
                        })
                    }

                })
            }
        }
    }
    
    /* ========== PROFILE CELL DELEGATE =========== */
    func changeAvatar() {
        view.endEditing(true)
        backgroundPopUpView.isHidden = false
    }
    
    /* ============= BOTTOM VIEW DELEGATE ============= */
    func updateProfile() {
        view.endEditing(true)
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        for i in 0..<dataArray.count {
            let key = keyArray[i]
            if key == "birthday" {
                if !ProjectCommon.birthdayIsValidate(string: dataArray[i]) {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Bạn không thể chọn ngày sinh ở tương lai", buttonArray: ["Đóng"], onCompletion: { (index) in
                    })
                    return
                }
            }
            if key != "email" {
                dictParam[keyArray[i]] = dataArray[i] as String?
            }
        }
        dictParam["lat"] = "\(lat)"
        dictParam["lng"] = "\(lng)"
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_DOCTOR, parameters: dictParam, onCompletion: {(response) in
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể cập nhật hồ sơ lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if let status = resultDictionary["status"] {
                    if (status as! NSNumber) == 1 {
                        // Post notification
                        NotificationCenter.default.post(name: Notification.Name(UPDATE_PROFILE_SUCCESS), object: nil)
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Cập nhật thành công", buttonArray: ["Đóng"], onCompletion: { (index) in
                            self.delegate?.registerDoctorSuccess()
                            _ = self.navigationController?.popViewController(animated: true)
                        })
                        return
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: resultDictionary["message"] as! String, buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }
                } else {
                    if resultDictionary["message"] != nil {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: resultDictionary["message"] as! String, buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Something went error!", buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }
                }
                
            }
            
        })
    }

    
    func cancel() {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }
    /* ============= CHANGE AVATAR VIEW DELEGATE ============= */
    
    func closePopup() {
        backgroundPopUpView.isHidden = true
    }
    
    func deleteAvatar() {
        backgroundPopUpView.isHidden = true
        imageAvatar = UIImage.init(named: "ic_avar_map")!
        var dictParam = [String:String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["image_id"] = userProfile?.avatar_id
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.deleteDataToURL(url: IMAGE_USER, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message:"Xin lỗi,không thể tải ảnh lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    NotificationCenter.default.post(name: Notification.Name(UPDATE_AVATAR_SUCCESS), object: nil)
                    self.tableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Xin lỗi,không thể tải ảnh lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    })
                }
            }
            
        })
    }
    
    func takePhoto() {
        backgroundPopUpView.isHidden = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func chooseFromLibrary() {
        backgroundPopUpView.isHidden = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    /* ============= IMAGE PICKER CONTROLLER DELEGATE ========= */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageAvatar = pickedImage
            self.updateAvatarUser()
            tableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateAvatarUser() -> Void {
        var dictParam = [String:String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["image_type"] = "profile"
        dictParam["image_title"] = ""
        dictParam["image_desc"] = ""
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.uploadImage(url: IMAGE_USER, image: imageAvatar, param: dictParam, completion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message:"Xin lỗi,không thể cập nhật ảnh lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    NotificationCenter.default.post(name: Notification.Name(UPDATE_AVATAR_SUCCESS), object: nil)
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Xin lỗi,không thể cập nhật ảnh lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    /**
     Show Address map view
     */
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        currentLocation = locations.last!
//        //Update location to server
//        //make new map after updated location
//        let center = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
//        let camera = GMSCameraPosition.camera(withLatitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude, zoom: 10)
//        mapView? = GMSMapView.map(withFrame:CGRect.init(x: 0, y: 0, width: view.frame.width, height:view.frame.height), camera: camera)
//        mapView?.isMyLocationEnabled = true
//        
//        
//        let confirmButton = UIButton.init(type: UIButtonType.custom)
//        confirmButton.frame = CGRect.init(x: 30, y: view.frame.size.height - 100, width: view.frame.size.width - 60, height: 40)
//        confirmButton.layer.cornerRadius = (confirmButton
//            .frame.height)/2
//        confirmButton.setTitleColor(UIColor.white, for: UIControlState.normal)
//        confirmButton.setTitle("XÁC NHẬN", for:  UIControlState.normal)
//        confirmButton.backgroundColor = UIColor(red: 24/255, green: 230/255, blue: 226/255, alpha: 1.0)
//        mapView?.addSubview(confirmButton)
//        
//        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = center
//        marker.map = mapView!
//        locationManager.stopUpdatingLocation()
//    }
    
    func initMapView() {
        let center = CLLocationCoordinate2D(latitude:lat, longitude: lng)
        let camera = GMSCameraPosition.camera(withLatitude:
            lat, longitude: lng, zoom: 14)
        mapView = GMSMapView.map(withFrame:CGRect.init(x: 0, y: 0, width: view.frame.width, height:view.frame.height), camera: camera)
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        
        let confirmButton = UIButton.init(type: UIButtonType.custom)
        confirmButton.frame = CGRect.init(x: 30, y: view.frame.size.height - 100, width: view.frame.size.width - 60, height: 40)
        confirmButton.layer.cornerRadius = (confirmButton
            .frame.height)/2
        confirmButton.addTarget(self, action: #selector(finishedConfirmLocation), for: UIControlEvents.touchUpInside)
        confirmButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        confirmButton.setTitle("XÁC NHẬN", for:  UIControlState.normal)
        confirmButton.backgroundColor = UIColor(red: 24/255, green: 230/255, blue: 226/255, alpha: 1.0)
        mapView.addSubview(confirmButton)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = center
        marker.map = mapView

    }
    
    func finishedConfirmLocation() {
        mapView.removeFromSuperview()
    }
    
    func searchLocationByAddress(address:String,onCompletion: @escaping AlamofireResponse) {
        let parameter = ["address":address,"key":googleKey]
        APIManager.sharedInstance.getDataFromFullUrl(url: "https://maps.googleapis.com/maps/api/geocode/json", parameters: parameter, onCompletion: { response in
            onCompletion(response)
            print(response)
        })
    }
}
