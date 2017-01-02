//
//  SelectBirthdayView.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 1/2/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

typealias onHiddenView = () -> Void
typealias onSaveBirthday = () -> Void

class SelectBirthdayView: UIView {
    @IBOutlet weak var datePicker: UIDatePicker!
    var hiddenBlock : onHiddenView?
    var saveBlock : onSaveBirthday?
    
    @IBAction func tappedHiddenButton(_ sender: Any) {
        hiddenBlock!()
    }
    @IBAction func tappedOKButton(_ sender: Any) {
        saveBlock!()
    }

    func initView(onHidden:@escaping onHiddenView, onSave:@escaping onSaveBirthday) -> Void {
        hiddenBlock = onHidden
        saveBlock = onSave
    }
    
    func showBirthDay(date:Date) -> Void {
        datePicker.date = date
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
