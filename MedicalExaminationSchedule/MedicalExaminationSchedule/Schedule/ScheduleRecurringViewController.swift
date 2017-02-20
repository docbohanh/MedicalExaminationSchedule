//
//  ScheduleRecurringViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/7/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ScheduleRecurringViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        var minute:Int = Int(hourLabel.text!)!
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
        var minute:Int = Int(hourLabel.text!)!
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
    
    @IBAction func tappedChooseDay(_ sender: UIButton) {
    }
    
    @IBAction func tappedRecurringWeek(_ sender: UIButton) {
    }
    
    @IBAction func setImageNotification(_ sender: UIButton) {
    }
    
    @IBAction func tappedSetupDate(_ sender: UIButton) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
