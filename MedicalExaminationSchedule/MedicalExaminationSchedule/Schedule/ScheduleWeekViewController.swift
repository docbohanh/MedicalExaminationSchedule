//
//  ScheduleWeekViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/7/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ScheduleWeekViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var setupImageButton: UIButton!
    @IBOutlet weak var setupDateButton: UIButton!
    
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var tuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thusdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var sundayButton: UIButton!
    
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    var scheduler: AlarmSchedulerDelegate = Scheduler()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    @IBAction func tappedExit(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSave(_ sender: UIButton) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeStr = dateFormatter.string(from: Date())
        
        Alarms.sharedInstance.append( Alarm(label: Global.label, timeStr: timeStr, date: Date(),  enabled: false, snoozeEnabled: Global.snoozeEnabled, UUID: UUID().uuidString, mediaID: "", mediaLabel: "bell", repeatWeekdays: Global.weekdays))
        scheduler.reSchedule()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedRecurring(_ sender: UIButton) {
    }
    @IBAction func tappedUpHour(_ sender: UIButton) {
        var hour:Int = Int(hourLabel.text!)!
        if hour < 12 {
            hour += 1
        } else {
            hour = 0
        }
        hourLabel.text = String(hour)
    }
    
    @IBAction func tappedDownHour(_ sender: UIButton) {
        var hour:Int = Int(hourLabel.text!)!
        if hour > 0 {
            hour -= 1
        } else {
            hour = 12
        }
        hourLabel.text = String(hour)
    }
    
    @IBAction func tappedUpMinute(_ sender: UIButton) {
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
    
    
    @IBAction func setImageNotification(_ sender: UIButton) {
    }
    @IBAction func tappedSetupDate(_ sender: UIButton) {
    }
    
    @IBAction func tappedChoosedTime(_ sender: UIButton) {
        if sender.title(for: UIControlState.normal) == "AM" {
            sender.setTitle("PM", for: UIControlState.normal)
        } else {
            sender.setTitle("AM", for: UIControlState.normal)
        }
    }
    
    @IBAction func tappedChoosedDay(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            sender.setTitleColor(UIColor.init(colorLiteralRed: 0/255, green: 122/255, blue: 255/255, alpha: 1), for: .normal)
        } else {
            sender.setTitleColor(UIColor.lightGray, for: .normal)
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
