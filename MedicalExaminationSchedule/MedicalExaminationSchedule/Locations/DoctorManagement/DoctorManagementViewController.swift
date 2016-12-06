//
//  DoctorManagementViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorManagementViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate {

    
    @IBOutlet weak var backgroundScrollView: UIScrollView!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        // Do any additional setup after loading the view.
    }

    func initUI() {
        commentView.isHidden = true
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
    
    @IBAction func tappedBookSchedule(_ sender: Any) {
        self.bookSchedule()
    }
    
    @IBAction func tappedSeeDoctorLocation(_ sender: Any) {
    }
    
    @IBAction func tappedDoctorProfile(_ sender: Any) {
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: doctorHistoryLabel.frame.size.height + doctorHistoryLabel.frame.origin.y + 20)
        tabLineView.center = CGPoint.init(x: profileTabButton.center.x, y: tabLineView.center.y)
        doctorHistoryLabel.isHidden = false
        commentView.isHidden = true
    }
    
    @IBAction func tappedDoctorInformation(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: informationTabButton.center.x, y: tabLineView.center.y)
    }
    
    @IBAction func tappedGetImageFromDevice(_ sender: UIButton) {
        tabLineView.center = CGPoint.init(x: imageTabButton.center.x, y: tabLineView.center.y)
    }
    @IBAction func tappedComment(_ sender: UIButton) {
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: sendCommentButton.frame.size.height + sendCommentButton.frame.origin.y + 20)
        tabLineView.center = CGPoint.init(x: commentTabButton.center.x, y: tabLineView.center.y)
        doctorHistoryLabel.isHidden = true
        commentView.isHidden = false
    }
    @IBAction func tappedSendComment(_ sender: UIButton) {
        
    }
    
    func bookSchedule() {
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: rateImageView.frame.size.height + rateImageView.frame.origin.y + 20 , width: self.view.bounds.width, height: 300))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.scopeGesture.isEnabled = true
        backgroundScrollView.addSubview(calendar)
    }
    // Update your frame
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: bounds.width, height: bounds.height)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
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
