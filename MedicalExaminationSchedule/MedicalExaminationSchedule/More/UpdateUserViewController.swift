//
//  UpdateUserViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UpdateUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, ProfileTableViewCellDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    var titleArray = [String]()
    
    var isDoctor = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ProjectCommon.boundWiewWithColor(button: updateButton, color: UIColor.clear)
        ProjectCommon.boundWiewWithColor(button: cancelButton, color: UIColor.clear)
        
        if isDoctor {
            titleArray += ["Họ Tên","Mật khẩu","Địa chỉ","Ngày sinh","Điện thoại","Nơi làm việc","Chuyên ngành", "Mã kích hoạt"]
        }else {
            titleArray += ["Họ Tên","Mật khẩu","Địa chỉ","Ngày sinh","Điện thoại","Email","Giới tính"]
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200.0;
        tableView.tableFooterView = bottomView
        // register cell
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib.init(nibName: "SelectGenderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectGenderTableViewCell")
        tableView.register(UINib.init(nibName: "TextFieldNormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldNormalTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ========  TABLE VIEW =========== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = ""
        if !isDoctor && indexPath.row == titleArray.count - 1 {
            strIdentifier = "SelectGenderTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGenderTableViewCell", for: indexPath) as! SelectGenderTableViewCell
            cell.titleLabel.text = titleArray[indexPath.row]
            return cell
        }
        switch indexPath.row {
        case 0:
            strIdentifier = "ProfileTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.delegate = self
            return cell
        default:
            strIdentifier = "TextFieldNormalTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldNormalTableViewCell", for: indexPath) as! TextFieldNormalTableViewCell
            cell.titleLabel.text = titleArray[indexPath.row]
            cell.cellTextField.delegate = self
            return cell
        }
    }
    
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedUpdateButton(_ sender: Any) {
    }
    @IBAction func tappedCancelButton(_ sender: Any) {
    }
    
    /* =========== TEXT FIELD ========*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /* ========== PROFILE CELL DELEGATE =========== */
    func changeAvatar() {
        
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
