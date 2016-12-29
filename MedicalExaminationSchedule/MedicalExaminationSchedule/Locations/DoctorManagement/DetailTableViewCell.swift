//
//  DetailTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DetailTableViewCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func initCell(object:IntroduceModel) -> Void {
        nameLabel.text = object.name
        descriptionLabel.text = object.desc
    }
}
