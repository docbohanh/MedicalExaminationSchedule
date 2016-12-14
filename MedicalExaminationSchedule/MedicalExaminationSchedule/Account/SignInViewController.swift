//
//  SignInViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var registerAccountButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var rememberButton: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupComponent()
    }
    
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: registerAccountButton)
        ProjectCommon.boundView(button: googleSignInButton)
        ProjectCommon.boundView(button: facebookSignInButton)
        ProjectCommon.boundView(button: signInButton)
        ProjectCommon.boundView(button: passwordView)
        ProjectCommon.boundView(button: userNameView)
    }

    @IBAction func tappedRegisterAccount(_ sender: Any) {
        
    }
    
    @IBAction func tappedSignInWithGoogle(_ sender: Any) {
        
    }
    
    @IBAction func tappedSignInWithFacebook(_ sender: Any) {
        
    }

    @IBAction func tappedSignIn(_ sender: Any) {
        
        view.endEditing(true)
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        if !ProjectCommon.isValidEmail(testStr: userNameTextField.text!) {
            alert.title = "Lỗi"
            alert.message = "Email không đúng định dạng"
            self.present(alert, animated: true, completion: nil)
            return
        }
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeMedhub.rawValue
        dictParam["email"] = userNameTextField.text
        dictParam["password"] = passwordTextField.text
        APIManager.sharedInstance.makeHTTPPostRequest(path:REST_API_URL + USER_POST_LOGIN, body: dictParam as [String:AnyObject], onCompletion: {(json, error) in
            print("json:", json)
            if (json["status"] as! NSNumber) == 1 {
                // success
                let dictResult = json["result"] as! [String:AnyObject]
                UserDefaults.standard.set(dictResult["token_id"], forKey: "token_id")
                self.performSegue(withIdentifier: "ShowTabBar", sender: self)
            }else {
                // success
                alert.title = "Lỗi"
                alert.message = error?.description
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func tappedRemember(_ sender: Any) {
        
    }
    
    /** 
     TextField delegate
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func setupNavigationBar() {
//        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
