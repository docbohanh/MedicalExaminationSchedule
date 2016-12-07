//
//  SetupScheduleViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SetupScheduleViewController: UIViewController,FSCalendarDataSource, FSCalendarDelegate {

    @IBOutlet weak var infomationView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var scpecializedLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    var isDoctor = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bookSchedule()
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBack(_ sender: UIButton) {
    }
    
    func bookSchedule() {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: infomationView.frame.size.height + infomationView.frame.origin.y , width: self.view.bounds.width, height: 260))
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.scopeGesture.isEnabled = true
        self.view.addSubview(calendar)
    }
    
    // Update your frame
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.frame = CGRect(x: 0, y: infomationView.frame.size.height + infomationView.frame.origin.y, width: bounds.width, height: bounds.height)
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        if !isDoctor {
            self.performSegue(withIdentifier: "setupSchedule", sender: nil)
        } else {
        
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
