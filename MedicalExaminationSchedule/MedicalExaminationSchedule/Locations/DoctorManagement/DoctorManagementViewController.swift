//
//  DoctorManagementViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorManagementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITextViewDelegate{

    
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
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    private weak var calendar: FSCalendar!
    let titleProfileArray = ["Họ tên","Địa chỉ","Giới tính","Chuyên nghành","Nơi làm việc"]
    let dataTestProfileArray = ["Nguyễn Hải Đăng","Hà Nội","Nam","Đa khoa","Bệnh viện Bạch Mai"]
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)

    
    @IBOutlet weak var informationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        imageCollectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotoCollectionViewCell")

        // Do any additional setup after loading the view.
    }

    func initUI() {
        commentView.isHidden = true
        informationTableView.isHidden = true
        imageCollectionView.isHidden = true
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
        if doctorHistoryLabel.isHidden {
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: doctorHistoryLabel.frame.size.height + doctorHistoryLabel.frame.origin.y + 20)
            tabLineView.center = CGPoint.init(x: profileTabButton.center.x, y: tabLineView.center.y)
            doctorHistoryLabel.isHidden = false
            commentView.isHidden = true
            informationTableView.isHidden = true
            imageCollectionView.isHidden = true
        }
    }
    
    @IBAction func tappedDoctorInformation(_ sender: UIButton) {
        if informationTableView.isHidden {
            tabLineView.center = CGPoint.init(x: informationTabButton.center.x, y: tabLineView.center.y)
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundScrollView.contentSize.height + backgroundInformationView.frame.size.height - 64)
            
            backgroundScrollView.scrollRectToVisible(CGRect.init(x: informationTabButton.frame.origin.x, y: backgroundInformationView.frame.size.height - informationTabButton.frame.size.height, width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.size.height), animated: true)
            informationTableView.isHidden = false
            doctorHistoryLabel.isHidden = true
            commentView.isHidden = true
            imageCollectionView.isHidden = true
        }
    }
    
    @IBAction func tappedGetImageFromDevice(_ sender: UIButton) {
        if imageCollectionView.isHidden {
            tabLineView.center = CGPoint.init(x: imageTabButton.center.x, y: tabLineView.center.y)
            doctorHistoryLabel.isHidden = true
            informationTableView.isHidden = true
            commentView.isHidden = true
            imageCollectionView.isHidden = false
        }
    }
    @IBAction func tappedComment(_ sender: UIButton) {
        if commentView.isHidden {
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: sendCommentButton.frame.size.height + sendCommentButton.frame.origin.y + 20)
            tabLineView.center = CGPoint.init(x: commentTabButton.center.x, y: tabLineView.center.y)
            doctorHistoryLabel.isHidden = true
            informationTableView.isHidden = true
            commentView.isHidden = false
            imageCollectionView.isHidden = true
        }
    }
    @IBAction func tappedSendComment(_ sender: UIButton) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
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
    
    
    /* ========== COLLECTION VIEW DELEGATE, DATA SOURCE ============ */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        return item
    }
    
    /*============== COLLECTION VIEW FLOW LAYOUT ============ */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow - 8
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
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
