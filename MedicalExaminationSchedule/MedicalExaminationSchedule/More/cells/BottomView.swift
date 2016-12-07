//
//  BottomView.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol BottomViewDelegate{
    func updateProfile() -> Void
    func cancel() -> Void
}

class BottomView: UIView {
    var delegate : BottomViewDelegate?
    
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override func awakeFromNib() {
        ProjectCommon.boundViewWithColor(button: updateButton, color: updateButton.backgroundColor!)
        ProjectCommon.boundViewWithColor(button: cancelButton, color: cancelButton.backgroundColor!)
    }
    
    @IBAction func tappedUpdateButton(_ sender: Any) {
        self.delegate?.updateProfile()
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.delegate?.cancel()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
