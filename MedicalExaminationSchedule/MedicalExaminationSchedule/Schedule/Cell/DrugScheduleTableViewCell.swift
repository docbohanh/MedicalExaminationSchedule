//
//  DrugScheduleTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/2/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DrugScheduleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mondayLabel: UILabel!
    @IBOutlet weak var tuedayLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursdayLabel: UILabel!
    @IBOutlet weak var fridayLabel: UILabel!
    @IBOutlet weak var saturdayLabel: UILabel!
    @IBOutlet weak var sundayLabel: UILabel!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
