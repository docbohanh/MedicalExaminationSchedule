//
//  FirstRegisterDoctorViewController.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol FirstRegisterDoctorVCDelegate {
    func registerDoctorSuccess() -> Void
}

class FirstRegisterDoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileTableViewCellDelegate, BottomViewDelegate, ChangeAvatarViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var delegate : FirstRegisterDoctorVCDelegate?
    @IBOutlet weak var backgroundPopUpView: UIView!
    var titleArray = [String]()
    var dataArray = [String]()
    var keyArray = [String]()
    
    var imageAvatar = UIImage()
    var isDoctor = false
    var isFirstRegisterDoctor = false
    var userProfile : UserModel?
    var changeBirthdayView :ChooseBirthdayView?
    var appdelegate = AppDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        appdelegate = UIApplication.shared.delegate as! AppDelegate

        titleArray += ["Họ Tên","Địa chỉ","Ngày sinh","Điện thoại","Nơi làm việc","Chuyên ngành", "Mã kích hoạt"]
        keyArray += ["user_display_name","home_address","birthday","phone","work_address","job","activate_code"]
        dataArray += [(self.userProfile?.user_display_name)!, (self.userProfile?.home_address)!, (self.userProfile?.birthday)!, (self.userProfile?.phone)!, (self.userProfile?.work_address)!, (self.userProfile?.job)!,""]
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200.0;
        
        let bottomButtonView = UINib(nibName: "BottomView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! BottomView
        bottomButtonView.delegate = self
        bottomButtonView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 170)
        tableView.tableFooterView = bottomButtonView

        // register cell
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib.init(nibName: "TextFieldNormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldNormalTableViewCell")
        self.createPopup()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
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
        return titleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         var strIdentifier = ""
        switch indexPath.row {
        case 0:
            strIdentifier = "ProfileTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.delegate = self
            cell.avatarImageView.image = imageAvatar
            return cell
        default:
            strIdentifier = "TextFieldNormalTableViewCell"
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
                if (key == "phone" || key == "activate_code") {
                    cell.cellTextField.keyboardType = UIKeyboardType.numberPad
                } else {
                    cell.cellTextField.keyboardType = UIKeyboardType.default
                }
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = keyArray[indexPath.row - 1]
        if (key == "birthday") {
            changeBirthdayView?.isHidden = false
            changeBirthdayView?.birthdayDatePicker.date = ProjectCommon.convertStringDate(string: dataArray[indexPath.row - 1])
        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
         self.navigationController?.popViewController(animated: true)
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
        view.endEditing(true)
        backgroundPopUpView.isHidden = false
    }
    
    /* ============= BOTTOM VIEW DELEGATE ============= */
    func updateProfile() {
//        self.delegate?.registerDoctorSuccess()
//        self.navigationController?.popViewController(animated: true)
        view.endEditing(true)
        var dictParam = [String : AnyObject]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as AnyObject?
        for i in 0..<dataArray.count {
            let key = keyArray[i]
            if key != "email" {
                dictParam[keyArray[i]] = dataArray[i] as AnyObject?
            }
        }
    }
    
    func cancel() {
        view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    /* ============= CHANGE AVATAR VIEW DELEGATE ============= */
    
    func closePopup() {
        backgroundPopUpView.isHidden = true
    }
    
    func deleteAvatar() {
        backgroundPopUpView.isHidden = true
        imageAvatar = UIImage.init(named: "ic_avar_map")!
        if appdelegate.avatarId == "" {
            return
        }
        
        var dictParam = [String:String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["image_id"] = appdelegate.avatarId
        
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.deleteDataToURL(url: IMAGE_USER, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    self.appdelegate.avatarId = ""
                    self.appdelegate.avatarUrl = ""
                    self.appdelegate.avatarImage = nil
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
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.uploadImage(url: IMAGE_USER, image: imageAvatar, param: dictParam, completion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    if let v = resultData["image_id"] {
                        self.appdelegate.avatarId = "\(v)"
                    }
                    self.appdelegate.avatarUrl = resultData["image_url"] as! String?
                    self.appdelegate.avatarImage = self.imageAvatar
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
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
