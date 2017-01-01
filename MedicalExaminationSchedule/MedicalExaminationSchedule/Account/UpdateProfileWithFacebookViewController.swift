//
//  UpdateProfileWithFacebookViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UpdateProfileWithFacebookViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var usernameTextField: CustomUITextField!
    @IBOutlet weak var emailTextField: CustomUITextField!
    @IBOutlet weak var addressTextField: CustomUITextField!
    @IBOutlet weak var phoneTextField: CustomUITextField!
    @IBOutlet weak var updateButton: UIButton!
    var social_token_id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupComponent()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissKeyboard() -> Void {
        view.endEditing(true)
    }
    
    @IBAction func tappedProfileFromFaceBook(_ sender: UIButton) {
        view.endEditing(true)
        
        if !ProjectCommon.isValidEmail(testStr: emailTextField.text!) {
            ProjectCommon.initAlertView(viewController: self, title: "Error", message: "Email không đúng định dạng", buttonArray: ["OK"], onCompletion: { (index) in
                
            })
            return
        }
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeMedhub.rawValue
        dictParam["user_display_name"] = usernameTextField.text
        dictParam["email"] = emailTextField.text
        dictParam["home_address"] = addressTextField.text
        dictParam["phone"] = phoneTextField.text
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_REGISTER, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)! , buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if let status = resultDictionary["status"] {
                    if (status as! NSNumber) == 1 {
                        ProjectCommon.initAlertView(viewController: self, title: "Success", message: "Đăng kí thành công", buttonArray: ["OK"], onCompletion: { (index) in
                            let value = resultDictionary["result"] as! [String:AnyObject]
                            UserDefaults.standard.set(value["token_id"], forKey: "token_id")
                            _ = self.navigationController?.popViewController(animated: false)
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
    
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: usernameTextField)
        ProjectCommon.boundView(button: emailTextField)
        ProjectCommon.boundView(button: addressTextField)
        ProjectCommon.boundView(button: phoneTextField)
        ProjectCommon.boundView(button: updateButton)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
