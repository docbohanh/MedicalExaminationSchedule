//
//  SettingCalendarViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/30/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SettingCalendarViewController: UIViewController, CKCalendarDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var freeLabel: UILabel!
    @IBOutlet weak var freeView: UIView!
    @IBOutlet weak var fullLabel: UILabel!
    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var callendarView: CKCalendarView!

    var selectedDate : Date?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView() -> Void {
        ProjectCommon.boundViewWithColor(button: freeView, color: UIColor.clear)
        ProjectCommon.boundViewWithColor(button: fullView, color: UIColor.clear)
        callendarView.isHidden = false;
        callendarView.delegate = self;
        callendarView.layer.cornerRadius = 5.0;
        callendarView.layer.borderColor = UIColor.lightGray.cgColor
        callendarView.layer.borderWidth = 1.0
        callendarView .select(Date(), makeVisible: true)
//        [callendarView selectDate:[NSDate date] makeVisible:YES];
        callendarView.onlyShowCurrentMonth = true;
        callendarView.adaptHeightToNumberOfWeeksInMonth = true;
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    /* CKCALENDAR */
    
    func calendar(_ calendar: CKCalendarView!, didSelect date: Date!) {
        selectedDate = date
        self.performSegue(withIdentifier: "PushToSetupTime", sender: self)
    }
    
    func calendar(_ calendar: CKCalendarView!, didChangeToMonth date: Date!) {
        
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "PushToSetupTime" {
            let vc = segue.destination as! SettingTimeViewController
            vc.selectedDate = selectedDate
        }
    }


}
