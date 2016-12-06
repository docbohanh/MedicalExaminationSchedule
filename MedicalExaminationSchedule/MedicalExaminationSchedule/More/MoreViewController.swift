//
//  MoreViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/4/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var moreTableView: UITableView!
    
    @IBOutlet weak var editMyProfileButton: UIButton!
    var iconArray = [String]()
    var titleArray = [String]()
    var isDoctor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        iconArray += ["ic_imadoctor","ic_imadoctor"]
        titleArray += ["Tôi là bác sỹ","Đóng góp ý kiến"]
        moreTableView.register(UINib.init(nibName: "NormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NormalTableViewCell")
        moreTableView.rowHeight = UITableViewAutomaticDimension;
        moreTableView.estimatedRowHeight = 70.0;
        moreTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    @IBAction func tappedSignOutButton(_ sender: Any) {
    }
    
    @IBAction func tappedMyProfileButton(_ sender: Any) {
        isDoctor = false
        self.performSegue(withIdentifier: "pushToUpdateUserProfile", sender: self)
    }
    
    /* ============= TABLEVIEW DELEGATE, DATASOURCE ============== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iconArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifierString = "NormalTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierString, for: indexPath) as! NormalTableViewCell
        cell.setupCell(icon: iconArray[indexPath.row], title: titleArray[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // tôi là bác sỹ
            isDoctor = true
            self.performSegue(withIdentifier: "pushToUpdateUserProfile", sender: self)
        } else if indexPath.row == 1 {
            // ý kiến
        }
     }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pushToUpdateUserProfile" {
            let updateVC = segue.destination as! UpdateUserViewController
            updateVC.isDoctor = isDoctor
            
        }
    }


}
