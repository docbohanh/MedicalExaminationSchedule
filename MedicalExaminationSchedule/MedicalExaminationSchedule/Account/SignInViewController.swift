//
//  SignInViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Alamofire
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit
import Google
import GoogleSignIn

class SignInViewController: UIViewController,UITextFieldDelegate, GIDSignInUIDelegate,GIDSignInDelegate {

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
        if (UserDefaults.standard.object(forKey: "remember_email") != nil) {
            userNameTextField.text = UserDefaults.standard.object(forKey: "remember_email") as! String?
        }
        if (UserDefaults.standard.object(forKey: "remember_password") != nil) {
            passwordTextField.text = UserDefaults.standard.object(forKey: "remember_password") as! String?
        }
        rememberButton.isSelected = UserDefaults.standard.bool(forKey: "remember")
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        if configureError != nil {
            print(configureError ?? "")
        }
        GIDSignIn.sharedInstance().clientID = "236770973454-ubijs6cfiepiu84vr0den9kh475gl2dk.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        print("in will dispatch")
        
    }

    func initializeFirstView() {
        if GIDSignIn.sharedInstance().hasAuthInKeychain(){
            logInToBackendServerAuthIdToken()
        } else{
        }
    }
    
    func logInToBackendServerAuthIdToken() {
        let user = GIDSignIn.sharedInstance().currentUser
        print(user) // fatal error: unexpectedly found nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initializeFirstView()
        if (UserDefaults.standard.object(forKey: "token_id") != nil) {
            self.performSegue(withIdentifier: "ShowTabBar", sender: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigationBar() {
        //        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupComponent() -> Void {
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
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func tappedSignInWithFacebook(_ sender: Any) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (response, error) in
            if(error == nil){
                print("No Error")
                if response?.token != nil {
                    if let tokenString = response?.token.tokenString {
                        self.loginServerWithFacebook(tokenFb: tokenString)
                        FBSDKAccessToken.current()
                        let loginManager = FBSDKLoginManager()
                        loginManager.logOut() // this is an instance function          
                    }
                }
            }
        })
    }
    
    @IBAction func tappedSignIn(_ sender: Any) {
        view.endEditing(true)
        if !ProjectCommon.isValidEmail(testStr: userNameTextField.text!) {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Email không đúng định dạng", buttonArray: ["Đóng"], onCompletion: { (index) in
            })
            return
        }
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeMedhub.rawValue
        dictParam["email"] = userNameTextField.text
        let datastring = ProjectCommon.sha256(string: passwordTextField.text!)
        dictParam["password"] = datastring as String?
//        dictParam["password"] = passwordTextField.text
        UserDefaults.standard.set(rememberButton.isSelected, forKey: "remember")
        if rememberButton.isSelected {
            UserDefaults.standard.set(userNameTextField.text, forKey: "remember_email")
            UserDefaults.standard.set(passwordTextField.text, forKey: "remember_password")
        }else {
            UserDefaults.standard.removeObject(forKey: "remember_email")
            UserDefaults.standard.removeObject(forKey: "remember_password")
        }
        self.callLoginApi(dictParam: dictParam)
    }
//
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    @IBAction func tappedRemember(_ sender: Any) {
        let button = sender as! UIButton
        button.isSelected = !button.isSelected
    }
    
    /** 
     TextField delegate
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print(error)
        }
        //        contentViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error == nil) {
            let idToken = user.authentication.accessToken //
//            UserDefaults.standard.set(idToken, forKey: "token_google")
            self.loginServerWithGooglePlus(tokenGoogle: idToken!)
            GIDSignIn.sharedInstance().signOut()
        } else {
            print("\(error.localizedDescription)")
        }
    }

    func loginServerWithFacebook(tokenFb:String) -> Void {
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeFacebook.rawValue
        dictParam["social_token_id"] = tokenFb
        self.callLoginApi(dictParam: dictParam)
    }
    
    func loginServerWithGooglePlus(tokenGoogle:String) -> Void {
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeGoogle.rawValue
        dictParam["social_token_id"] = tokenGoogle
        self.callLoginApi(dictParam: dictParam)
    }
    
    func callLoginApi(dictParam:[String:String]) -> Void {
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_LOGIN, parameters: dictParam, onCompletion: { (response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message:"Không thể kết nối để đăng nhập,vui lòng kiểm tra lại", buttonArray: ["Đóng"], onCompletion: { (index) in
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    let value = resultDictionary["result"] as! [String:AnyObject]
                    UserDefaults.standard.set(value["token_id"], forKey: "token_id")
                    self.performSegue(withIdentifier: "ShowTabBar", sender: self)
                }else {
                    if (resultDictionary["status"] as! NSNumber) == -1 {
                        if (dictParam["type"] == USER_TYPE.userTypeFacebook.rawValue || dictParam["type"] == USER_TYPE.userTypeGoogle.rawValue) {
                            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "UpdateProfileWithFacebookViewController")as! UpdateProfileWithFacebookViewController
                            vc.oldDict = dictParam
                            self.navigationController?.pushViewController(vc, animated: true)
                            return
                        }
                    }
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể kết nối để đăng nhập,vui lòng kiểm tra lại", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
}
