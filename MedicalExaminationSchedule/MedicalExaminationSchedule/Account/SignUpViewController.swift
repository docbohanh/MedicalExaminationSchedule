//
//  SignUpViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 11/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,UITextFieldDelegate,UIScrollViewDelegate {

    @IBOutlet weak var contentScrollview: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var accountTypeButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.setupScrollView()
    }
    @IBAction func tappedChooseAccountType(_ sender: Any) {
        
    }
    
    @IBAction func tappedRegisterNewAccount(_ sender: Any) {
        
    }
    
    @IBAction func tappedSignIn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedChooseMale(_ sender: Any) {
        
    }
    
    @IBAction func tappedChooseFemale(_ sender: Any) {
        
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
