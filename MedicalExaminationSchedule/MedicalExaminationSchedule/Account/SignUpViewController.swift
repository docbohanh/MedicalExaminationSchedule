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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupScrollView()
        self.setupComponent()
        self.tappedChooseMale(maleButton)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: signInButton.frame.size.height + signInButton.frame.origin.y + 10)
        scrollView.bounces = false
        backgroundImageView.frame.size.height = scrollView.contentSize.height
    }
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: femaleButton)
        ProjectCommon.boundView(button: maleButton)
        ProjectCommon.boundView(button: signInButton)
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
        
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        if !ProjectCommon.isValidEmail(testStr: emailTextField.text!) {
            alert.title = "Lỗi"
            alert.message = "Email không đúng định dạng"
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        var dictParam = [String : AnyObject]()
        dictParam["type"] = USER_TYPE.userTypeMedhub.rawValue as AnyObject?
        dictParam["email"] = emailTextField.text as AnyObject?
        dictParam["password"] = passwordTextField.text as AnyObject?
        dictParam["user_display_name"] = nameTextField.text as AnyObject?
        dictParam["phone"] = phoneTextField.text as AnyObject?
        if maleButton.isSelected {
            dictParam["sex"] = USER_SEX.userSexMale.rawValue as AnyObject?
        }else {
            dictParam["sex"] = USER_SEX.userSexFemale.rawValue as AnyObject?
        }
        dictParam["home_address"] = addressTextField.text as AnyObject?
        dictParam["birthday"] = chooseBirthdayButton.titleLabel?.text as AnyObject?
        APIManager.sharedInstance.makeHTTPPostRequest(path: REST_API_URL + USER_POST_REGISTER, body: dictParam, onCompletion: {(json,error) in
             print("json:", json)
            if (json["status"] as! NSNumber) == 1 {
                // success
                alert.title = "Đăng kí thành công"
                self.present(alert, animated: true, completion: nil)
            }else {
                // success
                alert.title = "Lỗi"
                alert.message = error?.description
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func tappedSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    func setupScrollView() {
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: 2*registerButton.frame.size.height + registerButton.frame.origin.y + 10)
    }
    func setupNavigationBar() {
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
    }
}
