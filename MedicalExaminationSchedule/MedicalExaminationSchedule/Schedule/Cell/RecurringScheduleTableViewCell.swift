//
//  RecurringScheduleTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/2/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class RecurringScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
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
