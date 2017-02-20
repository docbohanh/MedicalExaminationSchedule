//
//  RecurringScheduleTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/2/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
protocol RecurringScheduleAlarmDelegate {
    func changeRecurringScheduleAlarmStatus(sender:UIButton, at indexPath:IndexPath)
}
class RecurringScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var alarmButton: UIButton!
    @IBOutlet weak var amLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var indexPath = IndexPath()
    
    var delegate:RecurringScheduleAlarmDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func changeCurrentAlarmStatus(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.changeRecurringScheduleAlarmStatus(sender: sender, at: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
