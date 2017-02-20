//
//  DrugScheduleTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/2/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
protocol DrugScheduleAlarmDelegate {
    func changeDrugScheduleAlarmStatus(sender:UIButton, at indexPath:IndexPath)
}
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
    var delegate: DrugScheduleAlarmDelegate?
    var indexPath = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func changeCurrentAlarmStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.changeDrugScheduleAlarmStatus(sender: sender, at: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
