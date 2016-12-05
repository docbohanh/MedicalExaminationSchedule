//
//  DoctorAddressListViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorAddressListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var searchView: UIView!

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mapButton: UIButton!
    
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var segmentView: UIView!
    
    @IBOutlet weak var hospitalButton: UIButton!
    
    @IBOutlet weak var drugStore: UIButton!
    
    @IBOutlet weak var doctorButton: UIButton!
    
    @IBOutlet weak var clinicButton: UIButton!
    
    @IBOutlet weak var doctorAddressTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func tappedSearch(_ sender: UIButton) {
    }
    
    @IBAction func tappedHospitalSearch(_ sender: UIButton) {
    }
    
    @IBAction func tappedDrugStoreSearch(_ sender: UIButton) {
    }
    
    @IBAction func tappedDoctorSearch(_ sender: UIButton) {
    }
    
    @IBAction func tappedClinicSearch(_ sender: UIButton) {
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let titleLabel = Bundle.main.loadNibNamed("headerView", owner: self, options: nil)?.first as! headerView
        return titleLabel
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorAddressTableViewCell", for: indexPath) as! DoctorAddressTableViewCell
        return cell
    }
    
    
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
