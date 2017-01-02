//
//  UpdateProfileWithFacebookViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UpdateProfileWithFacebookViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: CustomUITextField!
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var addressTextField: CustomUITextField!
    @IBOutlet weak var phoneTextField: CustomUITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    var oldDict = [String: String]()
    
    @IBOutlet weak var birthDayLabel: UILabel!
    
    @IBOutlet weak var birthdayButton: UIButton!
    var chooseBirthdayView : SelectBirthdayView?
    
    
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupComponent()
        self.tappedMaleButton(maleButton)
        self.initChooseBirthdayView()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initChooseBirthdayView() -> Void {
        chooseBirthdayView = UINib(nibName: "SelectBirthdayView", bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as? SelectBirthdayView
        chooseBirthdayView?.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        chooseBirthdayView?.initView(onHidden: { 
            self.chooseBirthdayView?.isHidden = true
        }, onSave: { 
            self.chooseBirthdayView?.isHidden = true
            self.birthdayButton.setTitle(ProjectCommon.convertDateToString(date: (self.chooseBirthdayView?.datePicker.date)!), for: UIControlState.normal)
        })
        navigationController?.view.addSubview(chooseBirthdayView!)
        chooseBirthdayView?.isHidden = true
    }
    
    func setupScrollView() {
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height:updateButton.frame.size.height + updateButton.frame.origin.y)
    }
    
    func dismissKeyboard() -> Void {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            scrollViewBottomConstraint.constant = keyboardHeight - 50
            scrollView.layoutIfNeeded()
        }
    }
    
    func keyboardWillHidden(notification:NSNotification) {
        scrollViewBottomConstraint.constant = 0
        scrollView.layoutIfNeeded()
    }

    @IBAction func selectBirthDay(_ sender: Any) {
        chooseBirthdayView?.isHidden = false
        if birthdayButton.titleLabel?.text != "" && birthdayButton.titleLabel?.text != nil {
            chooseBirthdayView?.datePicker.date = ProjectCommon.convertStringDate(string: (birthdayButton.titleLabel?.text)!)
        }
    }
    
    @IBAction func tappedMaleButton(_ sender: Any) {
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }
    @IBAction func tappedFemaleButton(_ sender: Any) {
        maleButton.isSelected = false
        femaleButton.isSelected = true
    }
    @IBAction func tappedProfileFromFaceBook(_ sender: UIButton) {
        view.endEditing(true)
        
        if !ProjectCommon.isValidEmail(testStr: emailTextField.text!) {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Email không đúng định dạng", buttonArray: ["Đóng"], onCompletion: { (index) in
            })
            return
        }
        if !ProjectCommon.birthdayIsValidate(string: (birthdayButton.titleLabel?.text)!) {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Bạn không thể chọn ngày sinh ở tương lai", buttonArray: ["Đóng"], onCompletion: { (index) in
            })
            return
        }
        
        var dictParam = [String : String]()
        for item in oldDict {
            dictParam[item.key] = item.value
        }
        dictParam["user_display_name"] = usernameTextField.text
        dictParam["email"] = emailTextField.text
        dictParam["home_address"] = addressTextField.text
        dictParam["phone"] = phoneTextField.text
        if maleButton.isSelected {
            dictParam["sex"] = USER_SEX.userSexMale.rawValue as String
        }else {
            dictParam["sex"] = USER_SEX.userSexFemale.rawValue as String
        }
        dictParam["birthday"] = birthdayButton.titleLabel?.text
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_REGISTER, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Đã xảy ra lỗi", message: (response.result.error?.localizedDescription)! , buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if let status = resultDictionary["status"] {
                    if (status as! NSNumber) == 1 {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Đăng kí thành công", buttonArray: ["Đóng"], onCompletion: { (index) in
                            let value = resultDictionary["result"] as! [String:AnyObject]
                            UserDefaults.standard.set(value["token_id"], forKey: "token_id")
                            _ = self.navigationController?.popViewController(animated: false)
                        })
                        return
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "Đã xảy ra lỗi", message: resultDictionary["message"] as! String, buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }
                } else {
                    if resultDictionary["message"] != nil {
                        ProjectCommon.initAlertView(viewController: self, title: "Đã xảy ra lỗi", message: resultDictionary["message"] as! String, buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "Đã xảy ra lỗi", message: "", buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }
                }
                
            }
        })
    }
    
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: usernameTextField)
        ProjectCommon.boundView(button: emailTextField)
        ProjectCommon.boundView(button: addressTextField)
        ProjectCommon.boundView(button: phoneTextField)
        ProjectCommon.boundView(button: updateButton)
        ProjectCommon.boundView(button: femaleButton)
        ProjectCommon.boundView(button: maleButton)
        ProjectCommon.boundView(button: birthdayButton)
        self.setupScrollView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
