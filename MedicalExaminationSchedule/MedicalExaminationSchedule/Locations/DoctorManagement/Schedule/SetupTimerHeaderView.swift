//
//  SetupTimerHeaderView.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

protocol UpdateScheduleDelegate {
    func updateSchedule()
}
import UIKit

class SetupTimerHeaderView: UIView {
    var delegate: UpdateScheduleDelegate?
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func tappedUpdateSchedule(_ sender: UIButton) {
        delegate?.updateSchedule()
    }
}
