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

class SignInViewController: UIViewController,UITextFieldDelegate, LoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate {

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
    
    @IBOutlet weak var googleSignInView: GIDSignInButton!
    var loginButton : LoginButton?
    
    @IBAction func tappedSignInGoogle(_ sender: GIDSignInButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupComponent()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        loginButton = LoginButton(readPermissions: [ .publicProfile,.email,.userFriends])
        loginButton?.center = CGPoint(x: self.view.center.x, y: 200)
        loginButton?.frame = CGRect.init(x: facebookSignInButton.frame.origin.x, y: facebookSignInButton.frame.origin.y, width:view.frame.width - facebookSignInButton.frame.origin.x*2, height: facebookSignInButton.frame.height)
        loginButton?.delegate = self
        ProjectCommon.boundView(button: loginButton!)
        view.addSubview(loginButton!)

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
        self.initializeFirstView()
        if (FBSDKAccessToken.current()) != nil{
            print("da dong y cho phep su dung facebook")
            //User is already logged-in. Please do your additional code/task.
        }else{
            print("Khong dong y")

            //User is not logged-in. Allow the user for login using FB.
        }
        if (UserDefaults.standard.object(forKey: "token_id") != nil) {
            self.performSegue(withIdentifier: "ShowTabBar", sender: self)
        }
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
        
    }
    
    @IBAction func tappedSignInWithFacebook(_ sender: Any) {
    }

    @IBAction func tappedSignIn(_ sender: Any) {
        view.endEditing(true)
        if !ProjectCommon.isValidEmail(testStr: userNameTextField.text!) {
            ProjectCommon.initAlertView(viewController: self, title: "Error", message: "Email không đúng định dạng", buttonArray: ["OK"], onCompletion: { (index) in
                
            })
            return
        }
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeMedhub.rawValue
        dictParam["email"] = userNameTextField.text
        let datastring = ProjectCommon.sha256(string: passwordTextField.text!)
        dictParam["password"] = datastring as String?
//        dictParam["password"] = passwordTextField.text
        self.callLoginApi(dictParam: dictParam)
    }
    

//    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        print("Did complete login via LoginButton with result \(result)")
        switch result {
        case .failed( _):
        // User log in failed with error
            break
        case .cancelled:
        // User cancelled login
            break
        case .success:
            // Log in user
            let fbAccessToken = FBSDKAccessToken.current().tokenString as String
            print ("Token Id" + fbAccessToken)
            UserDefaults.standard.set(fbAccessToken, forKey: "token_fb")
            self.loginServerWithFacebook(tokenFb: fbAccessToken)
            break
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        print("Did logout via LoginButton")
    }
    
//    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
//                withError error: NSError!) {
//        if (error == nil) {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            // ...
//        } else {
//            print("\(error.localizedDescription)")
//        }
//    }
    
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if (error) != nil {
            print(error)
        }
        
        //        contentViewController.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }

    func loginServerWithFacebook(tokenFb:String) -> Void {
        var dictParam = [String : String]()
        dictParam["type"] = USER_TYPE.userTypeFacebook.rawValue
        dictParam["social_token_id"] = tokenFb
        self.callLoginApi(dictParam: dictParam)
    }
    
    func callLoginApi(dictParam:[String:String]) -> Void {
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_LOGIN, parameters: dictParam, onCompletion: { (response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
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
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })

    }
    
}
