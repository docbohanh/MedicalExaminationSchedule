//
//  SignUpViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var contentScrollview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordTextField: CustomUITextField!
    @IBOutlet weak var phoneTextField: CustomUITextField!
    @IBOutlet weak var addressTextField: CustomUITextField!
    @IBOutlet weak var nameTextField: CustomUITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var chooseBirthdayView: UIView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var choosePickerView: UIView!
    @IBOutlet weak var okBirthdayButton: UIButton!
    @IBOutlet weak var chooseBirthdayButton: UIButton!
    @IBOutlet weak var scrollViewBottomContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        // Do any additional setup after loading the view.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
//        self.setupScrollView()
        self.setupComponent()
        self.tappedChooseMale(maleButton)
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Screen SignUp ~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    func dismissKeyboard() -> Void {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            scrollViewBottomContraint.constant = keyboardHeight
            scrollView.layoutIfNeeded()
        }
    }
    
    func keyboardWillHidden(notification:NSNotification) {
        scrollViewBottomContraint.constant = 0
        scrollView.layoutIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: signInButton.frame.size.height + signInButton.frame.origin.y)
        scrollView.layoutIfNeeded()
    }
    
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: femaleButton)
        ProjectCommon.boundView(button: maleButton)
        ProjectCommon.boundView(button: registerButton)
        ProjectCommon.boundView(button: passwordTextField)
        ProjectCommon.boundView(button: phoneTextField)
        ProjectCommon.boundView(button: addressTextField)
        ProjectCommon.boundView(button: nameTextField)
        ProjectCommon.boundView(button: emailTextField)
        ProjectCommon.boundView(button: chooseBirthdayButton)
        ProjectCommon.boundView(button: okBirthdayButton)
        ProjectCommon.boundView(button: choosePickerView, cornerRadius: 5.0, color: UIColor.clear, borderWith: 0)
    }
    
    @IBAction func tappedRegisterNewAccount(_ sender: Any) {
        view.endEditing(true)
        
        if !ProjectCommon.isValidEmail(testStr: emailTextField.text!) {
            ProjectCommon.initAlertView(viewController: self, title: "Lỗi", message: "Email không đúng định dạng", buttonArray: ["Đóng"], onCompletion: { (index) in
            })
            return
        }
        if !ProjectCommon.birthdayIsValidate(string: (chooseBirthdayButton.titleLabel?.text)!) {
            ProjectCommon.initAlertView(viewController: self, title: "Lỗi", message: "Ngày sinh không thể là ngày tương lai", buttonArray: ["Đóng"], onCompletion: { (index) in
            })
            return
        }
        
        var dictParam = [String : AnyObject]()
        dictParam["type"] = USER_TYPE.userTypeMedhub.rawValue as AnyObject?
        dictParam["email"] = emailTextField.text as AnyObject?
        let datastring = ProjectCommon.sha256(string: passwordTextField.text!)
        dictParam["password"] = datastring as AnyObject?
        dictParam["user_display_name"] = nameTextField.text as AnyObject?
        dictParam["phone"] = phoneTextField.text as AnyObject?
        if maleButton.isSelected {
            dictParam["sex"] = USER_SEX.userSexMale.rawValue as AnyObject?
        }else {
            dictParam["sex"] = USER_SEX.userSexFemale.rawValue as AnyObject?
        }
        dictParam["home_address"] = addressTextField.text as AnyObject?
        dictParam["birthday"] = chooseBirthdayButton.titleLabel?.text as AnyObject?
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_REGISTER, parameters: dictParam as! [String : String], onCompletion: {(response) in
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá tình đăng ký,vui lòng quay lại sau" , buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if let status = resultDictionary["status"] {
                    if (status as! NSNumber) == 1 {
                        if let result = resultDictionary["result"] as? [String:AnyObject] {
                            if result["token_id"] != nil {
                                UserDefaults.standard.set(result["token_id"], forKey: "token_id")
                            }
                        }
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Đăng kí thành công", buttonArray: ["Đóng"], onCompletion: { (index) in
                            self.dismiss(animated: true, completion: nil)
                            //_ = self.navigationController?.popViewController(animated: true)
                        })
                        return
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá tình đăng ký,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }
                } else {
                    if resultDictionary["message"] != nil {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá tình đăng ký,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }else {
                        ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá tình đăng ký,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        })
                    }
                }

            }
        })
    }
    
    @IBAction func tappedSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
//        _ =  navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedChooseMale(_ sender: Any) {
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }
    
    @IBAction func tappedChooseFemale(_ sender: Any) {
        maleButton.isSelected = false
        femaleButton.isSelected = true
    }
    
    @IBAction func chooseBirthdayButton(_ sender: Any) {
        chooseBirthdayView.isHidden = false
    }
    
    @IBAction func closePickerView(_ sender: Any) {
        chooseBirthdayView.isHidden = true
    }
    
    @IBAction func tappedOKBirthdayButton(_ sender: Any) {
        chooseBirthdayView.isHidden = true
        chooseBirthdayButton.setTitle(ProjectCommon.convertDateToString(date: datePickerView.date), for: UIControlState.normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Delegate
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func setupNavigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
}
