//
//  ScheduleRecurringViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/7/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ScheduleRecurringViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource,CKCalendarDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loopPickerView: UIPickerView!

    @IBOutlet weak var startDateButton: UIButton!
    @IBOutlet weak var loopButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var backgoundButton: UIButton!
    
    @IBOutlet weak var calendarView: CKCalendarView!
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self;
        calendarView.layer.cornerRadius = 5.0;
        calendarView.layer.borderColor = UIColor.lightGray.cgColor
        calendarView.layer.borderWidth = 1.0
        calendarView.select(Date(), makeVisible: true)
        calendarView.onlyShowCurrentMonth = true;
        calendarView.adaptHeightToNumberOfWeeksInMonth = true;
        // Do any additional setup after loading the view.
    }
    @IBAction func tappedBackground(_ sender: UIButton) {
        sender.isHidden = true
        calendarView.isHidden = true
    }
    @IBAction func tappedUpHour(_ sender: UIButton) {
        var hour = Int(hourLabel.text!)
        
        if hour! < 12 {
            hour! += 1
        } else {
            hour = 1
        }
        hourLabel.text = String(hour!)
    }
    
    @IBAction func tappedDownHour(_ sender: UIButton) {
        var hour = Int(hourLabel.text!)
        
        if hour! < 2 {
            hour = 12
        } else {
            hour! -= 1
        }
        hourLabel.text = String(hour!)
    }
    
    @IBAction func tappedUpMinute(_ sender: Any) {
        var minute:Int = Int(minuteLabel.text!)!
        if minute < 59 {
            minute += 1
        } else {
            minute = 0
        }
        if minute < 10 {
            minuteLabel.text = "0" + String(minute)
        } else {
            minuteLabel.text = String(minute)
        }
    }
    
    @IBAction func tappedDownMinute(_ sender: UIButton) {
        var minute:Int = Int(minuteLabel.text!)!
        if minute > 0 {
            minute -= 1
        } else {
            minute = 59
        }
        if minute < 10 {
            minuteLabel.text = "0" + String(minute)
        } else {
            minuteLabel.text = String(minute)
        }
    }
    
    @IBAction func tappedChooseTime(_ sender: UIButton) {
        if sender.title(for: UIControlState.normal) == "AM" {
            sender.setTitle("PM", for: UIControlState.normal)
        } else {
            sender.setTitle("AM", for: UIControlState.normal)
        }
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedExit(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSave(_ sender: UIButton) {
    }
    
    @IBAction func chooseStartDate(_ sender: UIButton) {
        calendarView.isHidden = false
        backgoundButton.isHidden = false
        loopPickerView.isHidden = true
    }
    @IBAction func tappedChooseDay(_ sender: UIButton) {
        loopPickerView.isHidden = !loopPickerView.isHidden
    }
    
    @IBAction func tappedRecurringWeek(_ sender: UIButton) {
    }
    
    @IBAction func setImageNotification(_ sender: UIButton) {
        
    }
    
    @IBAction func tappedSetupDate(_ sender: UIButton) {
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        loopButton.setTitle(String(row), for: UIControlState.normal)
    }
    
    func calendar(_ calendar: CKCalendarView!, didChangeToMonth date: Date!) {
    }
    
    func calendar(_ calendar: CKCalendarView!, didSelect date: Date!) {
        // your code here
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        startDateButton.setTitle(dateFormatter.string(from: date), for: UIControlState.normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
