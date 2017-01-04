//
//  DoctorAddressTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorAddressTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var doctorNameLabel: UILabel!
    
    @IBOutlet weak var locationIconImageView: UIImageView!
    @IBOutlet weak var doctorAddressLabel: UILabel!
    var serviceDetail : ServiceModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(object:ServiceModel) -> Void {
        doctorNameLabel.text = object.name
        doctorAddressLabel.text = object.address
        serviceDetail = object
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
