//
//  InviteDoctorTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class InviteDoctorTableViewCell: UITableViewCell {

    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var choosedDoctorImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initCell(object:UserSearchModel) -> Void {
        doctorNameLabel.text = object.name
        emailLabel.text = object.email
        choosedDoctorImageView.isHidden = object.isSelected
    }

}
