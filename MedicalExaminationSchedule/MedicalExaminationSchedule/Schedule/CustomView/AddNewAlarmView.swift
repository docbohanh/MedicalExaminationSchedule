//
//  AddNewAlarmView.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/7/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
protocol SelectAlarmTypeDelegate {
    func selectAlarm(type:ALARM_TYPE)
    
}
class AddNewAlarmView: UIView {
    var delegate:SelectAlarmTypeDelegate?

    @IBAction func tappedSelectRecurringSchedule(_ sender: UIButton) {
        delegate?.selectAlarm(type: .recurring)
    }
    @IBAction func tappedSelectWeekSchedule(_ sender: UIButton) {
        delegate?.selectAlarm(type: .week)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
