//
//  AlarmTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/20/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuedayLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!

    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UIView!
    @IBOutlet weak var numOfLoop: UILabel!
    
    var scheduler: AlarmSchedulerDelegate = Scheduler()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func tappedChangeAlarmStatus(_ sender: UIButton) {
        Global.indexOfCell = sender.tag
        Alarms.sharedInstance.setEnabled(sender.isSelected, AtIndex: sender.tag)
        Alarms.sharedInstance.PersistAlarm(sender.tag)
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected
        {
            print("switch on")
            sender.superview?.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            scheduler.setNotificationWithDate(Alarms.sharedInstance[sender.tag].date, onWeekdaysForNotify: Alarms.sharedInstance[sender.tag].repeatWeekdays, snooze: Alarms.sharedInstance[sender.tag].snoozeEnabled, soundName: Alarms.sharedInstance[sender.tag].mediaLabel, index: sender.tag)
        }
        else
        {
            print("switch off")
            sender.superview?.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
            scheduler.reSchedule()
            
        }
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
