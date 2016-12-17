//
//  ChooseBirthdayView.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/16/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

typealias DatePickerClickButton = (UIButton) -> Void

class ChooseBirthdayView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var datePickerview: UIView!
    
    var datePickerClick : DatePickerClickButton?
    

    override func awakeFromNib() {
        datePickerview.clipsToBounds = true
        datePickerview.layer.cornerRadius = 5.0
    }
    
    func setupView(clickButton : @escaping DatePickerClickButton) -> Void {
        datePickerClick = clickButton
    }
    
    @IBAction func tapped_hiddenButton(_ sender: Any) {
        self.datePickerClick!(sender as! UIButton)
    }
    @IBAction func tapped_saveButton(_ sender: Any) {
       self.datePickerClick!(sender as! UIButton)
    }
}
