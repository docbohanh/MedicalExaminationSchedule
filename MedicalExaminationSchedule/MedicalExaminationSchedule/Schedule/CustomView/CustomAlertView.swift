//
//  CustomAlertView.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/5/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
protocol AlertAlarmDelegate {
    func editAlarm(type:EDIT_ALARM)
    
}

class CustomAlertView: UIView {
    var delegate:AlertAlarmDelegate?
    
    @IBOutlet weak var backgroundButton: UIButton!
    
    @IBAction func tappedEdit(_ sender: UIButton) {
        delegate?.editAlarm(type: .edit)
    }
    @IBAction func tappedDelete(_ sender: UIButton) {
        delegate?.editAlarm(type: .delete)
    }
    
    @IBAction func tappedHideView(_ sender: UIButton) {
        delegate?.editAlarm(type: .hideView)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
