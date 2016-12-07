//
//  UpdateProfileWithFacebookViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UpdateProfileWithFacebookViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.setupComponent()
    }

    @IBAction func tappedProfileFromFaceBook(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupComponent() -> Void {
        ProjectCommon.boundView(button: usernameTextField)
        ProjectCommon.boundView(button: emailTextField)
        ProjectCommon.boundView(button: addressTextField)
        ProjectCommon.boundView(button: phoneTextField)
        ProjectCommon.boundView(button: updateButton)
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
