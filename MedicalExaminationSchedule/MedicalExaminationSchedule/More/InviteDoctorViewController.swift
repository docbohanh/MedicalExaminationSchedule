//
//  InviteDoctorViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class InviteDoctorViewController: UIViewController {
    @IBOutlet weak var searchtextField: UITextField!

    @IBOutlet weak var doctorListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedInviteDoctor(_ sender: UIButton) {
    }
    @IBAction func tappedSearch(_ sender: Any) {
    }
    @IBOutlet weak var tappedBack: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
