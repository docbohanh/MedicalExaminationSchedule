//
//  InformationDoctorViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class InformationDoctorViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    let titleProfileArray = ["Họ tên","Địa chỉ","Giới tính","Chuyên nghành","Nơi làm việc"]
    let dataTestProfileArray = ["Nguyễn Hải Đăng","Hà Nội","Nam","Đa khoa","Bệnh viện Bạch Mai"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 44
        }
            return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 220
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("RateHeaderView", owner: self, options: nil)?.first as! RateHeaderView
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileTableViewCell", for: indexPath) as! DoctorProfileTableViewCell
            if titleProfileArray.count > indexPath.row {
                cell.titleProfileLabel.text = titleProfileArray[indexPath.row]
                cell.valueProfileLabel.text = dataTestProfileArray[indexPath.row]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            return cell
        }
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
