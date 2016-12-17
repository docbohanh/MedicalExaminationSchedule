//
//  SignInViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Alamofire

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
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    @IBOutlet weak var waitingView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupComponent()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        waitingView.isHidden = true
    }
    
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: registerAccountButton)
        ProjectCommon.boundView(button: googleSignInButton)
        ProjectCommon.boundView(button: facebookSignInButton)
        ProjectCommon.boundView(button: signInButton)
        ProjectCommon.boundView(button: passwordView)
        ProjectCommon.boundView(button: userNameView)
    }
    
    func dismissKeyboard() -> Void {
        view.endEditing(true)
    }
    

    @IBAction func tappedRegisterAccount(_ sender: Any) {
        
    }
    
    @IBAction func tappedSignInWithGoogle(_ sender: Any) {
        
    }
    
    @IBAction func tappedSignInWithFacebook(_ sender: Any) {
        
    }

    @IBAction func tappedSignIn(_ sender: Any) {
        waitingView.isHidden = false
        view.endEditing(true)
        
//        Alamofire.request("https://httpbin.org/get").responseJSON { response in
//            print(response.request)  // original URL request
//            print(response.response) // HTTP URL response
//            print(response.data)     // server data
//            print(response.result)   // result of response serialization
//            
//            if let JSON = response.result.value {
//                print("JSON: \(JSON)")
//            }
//        }
        
        
        
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

        APIManager.sharedInstance.postDataToURL(url: USER_POST_LOGIN, parameters: dictParam, onCompletion: { (response) in
            print(response)
            if !Thread.isMainThread {
                DispatchQueue.main.sync {
                    self.waitingView.isHidden = true
                    if response.result.error != nil {
                        alert.title = "Lỗi"
                        alert.message = response.result.error?.localizedDescription
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let value = response.result.value as? [String:AnyObject]
                        UserDefaults.standard.set(value?["token_id"], forKey: "token_id")
                        self.performSegue(withIdentifier: "ShowTabBar", sender: self)
                    }
                }
            } else {
                self.waitingView.isHidden = true
                if response.result.error != nil {
                    alert.title = "Error"
                    alert.message = response.result.error?.localizedDescription
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let value = response.result.value as? [String:AnyObject]
                    UserDefaults.standard.set(value?["token_id"], forKey: "token_id")
                    self.performSegue(withIdentifier: "ShowTabBar", sender: self)
                }
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
