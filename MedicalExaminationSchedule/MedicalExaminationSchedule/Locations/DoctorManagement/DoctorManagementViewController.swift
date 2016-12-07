//
//  DoctorManagementViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorManagementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var backgroundInformationView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var doctorSpecializedLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var profileTabButton: UIButton!
    @IBOutlet weak var informationTabButton: UIButton!
    @IBOutlet weak var imageTabButton: UIButton!
    @IBOutlet weak var commentTabButton: UIButton!
    @IBOutlet weak var tabLineView: UIView!
    @IBOutlet weak var doctorHistoryLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var makeRateImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendCommentButton: UIButton!
    private weak var calendar: FSCalendar!
    let titleProfileArray = ["Họ tên","Địa chỉ","Giới tính","Chuyên nghành","Nơi làm việc"]
    let dataTestProfileArray = ["Nguyễn Hải Đăng","Hà Nội","Nam","Đa khoa","Bệnh viện Bạch Mai"]
    
    @IBOutlet weak var informationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }

    func initUI() {
        commentView.isHidden = true
        informationTableView.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.origin.y + doctorHistoryLabel.frame.size.height + doctorHistoryLabel.frame.origin.y)
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCallDoctor(_ sender: UIButton) {
    }
    
    @IBAction func tappedSeeDoctorLocation(_ sender: Any) {
    }
    
    @IBAction func tappedDoctorProfile(_ sender: Any) {
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: doctorHistoryLabel.frame.size.height + doctorHistoryLabel.frame.origin.y + 20)
        tabLineView.center = CGPoint.init(x: profileTabButton.center.x, y: tabLineView.center.y)
        doctorHistoryLabel.isHidden = false
        commentView.isHidden = true
        informationTableView.isHidden = true

    }
    
    @IBAction func tappedDoctorInformation(_ sender: UIButton) {
        if informationTableView.isHidden {
            tabLineView.center = CGPoint.init(x: informationTabButton.center.x, y: tabLineView.center.y)
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundScrollView.contentSize.height + backgroundInformationView.frame.size.height - 64)
            
            backgroundScrollView.scrollRectToVisible(CGRect.init(x: informationTabButton.frame.origin.x, y: backgroundInformationView.frame.size.height - informationTabButton.frame.size.height, width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.size.height), animated: true)
            informationTableView.isHidden = false
            doctorHistoryLabel.isHidden = true
            commentView.isHidden = true
        }
    }
    
    @IBAction func tappedGetImageFromDevice(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: imageTabButton.center.x, y: tabLineView.center.y)
        doctorHistoryLabel.isHidden = true
        informationTableView.isHidden = true
        commentView.isHidden = true
    }
    @IBAction func tappedComment(_ sender: UIButton) {
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: sendCommentButton.frame.size.height + sendCommentButton.frame.origin.y + 20)
        tabLineView.center = CGPoint.init(x: commentTabButton.center.x, y: tabLineView.center.y)
        doctorHistoryLabel.isHidden = true
        informationTableView.isHidden = true
        commentView.isHidden = false
    }
    @IBAction func tappedSendComment(_ sender: UIButton) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setupScheduleOfUser" {
            let setupScheduleViewController = segue.destination as? SetupScheduleViewController
            setupScheduleViewController?.isDoctor = false
        }
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
