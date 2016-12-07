//
//  SetupTimerTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SetupTimerTableViewCell: UITableViewCell {

    @IBOutlet weak var fromHourTextField: UITextField!
    @IBOutlet weak var toHourTextField: UITextField!
    @IBOutlet weak var fromMinuteTextField: UITextField!
    @IBOutlet weak var toMinuteTextField: UITextField!
    @IBOutlet weak var removeScheduleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tappedRemoveSchedule(_ sender: UIButton) {
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
