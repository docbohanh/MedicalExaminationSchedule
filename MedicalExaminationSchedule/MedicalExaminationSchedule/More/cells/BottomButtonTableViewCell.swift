//
//  BottomButtonTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 1/1/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol BottomViewCellDelegate{
    func updateProfile() -> Void
    func cancel() -> Void
}


class BottomButtonTableViewCell: UITableViewCell {

    var delegate : BottomViewCellDelegate?
    
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
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
