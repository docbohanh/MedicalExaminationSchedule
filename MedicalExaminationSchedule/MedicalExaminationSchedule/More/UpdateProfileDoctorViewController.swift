//
//  UpdateProfileDoctorViewController.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UpdateProfileDoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileTableViewCellDelegate, ChangeAvatarViewDelegate, SelectGengerTableViewCellDelegate, BottomViewCellDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var updateButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backgroundPopUpView: UIView!
    var titleArray = [String]()
    var keyArray = [String]()
    var dataArray = [String]()
    var imageAvatar = UIImage()
    var isDoctor = false
    var isFirstRegisterDoctor = false
    var userProfile : UserModel?
    var changeBirthdayView : ChooseBirthdayView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleArray += ["Họ Tên","Địa chỉ","Ngày sinh","Điện thoại","Email","Chuyên ngành","Nơi làm việc", "Giới tính"]
        keyArray += ["user_display_name","home_address","birthday","phone","email","job","work_address","sex"]
        dataArray += [(self.userProfile?.user_display_name)!, (self.userProfile?.home_address)!, (self.userProfile?.birthday)!, (self.userProfile?.phone)!, (self.userProfile?.email)!, (self.userProfile?.job)!, (self.userProfile?.work_address)!,(self.userProfile?.sex)!]
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200.0;

        // register cell
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib.init(nibName: "SelectGenderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectGenderTableViewCell")
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
        case titleArray.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGenderTableViewCell", for: indexPath) as! SelectGenderTableViewCell
            cell.delegate = self
            cell.titleLabel.text = titleArray[indexPath.row - 1]
            if dataArray[indexPath.row - 1] == USER_SEX.userSexMale.rawValue {
                cell.tappedMaleButton(cell.maleButton)
            }else {
                cell.tappedFemaleButton(cell.femaleButton)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldNormalTableViewCell", for: indexPath) as! TextFieldNormalTableViewCell
            cell.titleLabel.text = titleArray[indexPath.row - 1]
            cell.cellTextField.delegate = self
            cell.cellTextField.text = dataArray[indexPath.row - 1]
            cell.cellTextField.tag = indexPath.row - 1
            let key = keyArray[indexPath.row - 1]
            if (key == "email" || key == "birthday") {
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
        
    }
    
    /* ========== PROFILE CELL DELEGATE =========== */
    func changeAvatar() {
        backgroundPopUpView.isHidden = false
    }
    
    /* ============= BOTTOM VIEW DELEGATE ============= */
    func updateProfile() {
        view.endEditing(true)
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        for i in 0..<dataArray.count {
            let key = keyArray[i]
            if key == "birthday" {
                if !ProjectCommon.birthdayIsValidate(string: dataArray[i]) {
                    ProjectCommon.initAlertView(viewController: self, title: "Lỗi", message: "Ngày sinh không thể là ngày tương lai", buttonArray: ["OK"], onCompletion: { (index) in
                    })
                    return
                }
            }
            if key != "email" {
                dictParam[keyArray[i]] = dataArray[i] as String?
            }
        }
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_INFO, parameters: dictParam, onCompletion: {(response) in
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)! , buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if let status = resultDictionary["status"] {
                    if (status as! NSNumber) == 1 {
                        // Post notification
                        NotificationCenter.default.post(name: Notification.Name(UPDATE_PROFILE_SUCCESS), object: nil)
                        ProjectCommon.initAlertView(viewController: self, title: "Success", message: "Cập nhật thành công", buttonArray: ["OK"], onCompletion: { (index) in
                        })
                        return
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        })
                    }
                } else {
                    if resultDictionary["message"] != nil {
                        ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        })
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "Error", message: "Something went error!", buttonArray: ["OK"], onCompletion: { (index) in
                        })
                    }
                }
                
            }
            
        })

    }
    
    func cancel() {
        _ = navigationController?.popViewController(animated: true)
    }
    
     /* ============= SELECT GENDER DELEGATE ============ */
    func tappGenderButton(button: UIButton) {
        view.endEditing(true)
        if (button.tag == 0) {
            //male
            dataArray[dataArray.count-1] = USER_SEX.userSexMale.rawValue
        }else {
            // female
            dataArray[dataArray.count-1] = USER_SEX.userSexMale.rawValue
        }
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
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    NotificationCenter.default.post(name: Notification.Name(UPDATE_AVATAR_SUCCESS), object: nil)
                    self.tableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
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
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    NotificationCenter.default.post(name: Notification.Name(UPDATE_AVATAR_SUCCESS), object: nil)
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
}
