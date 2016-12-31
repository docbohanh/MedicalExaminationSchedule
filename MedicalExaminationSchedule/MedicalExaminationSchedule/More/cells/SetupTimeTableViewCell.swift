//
//  SetupTimeTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol SetupTimeCellDelegate {
    func deleteCalendar(cell:SetupTimeTableViewCell) -> Void
    func selectTime(cell:SetupTimeTableViewCell,buttonTag:Int) -> Void
}

class SetupTimeTableViewCell: UITableViewCell {

    @IBOutlet weak var startHourButton: UIButton!
    @IBOutlet weak var startMinutesButton: UIButton!
    @IBOutlet weak var endHoursButton: UIButton!
    @IBOutlet weak var endMinutesButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var delegate : SetupTimeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let radius = CGFloat(2.0)
        let borderWith = CGFloat(1.0)
        let borderColor = UIColor.lightGray
        
        ProjectCommon.boundView(button: startHourButton, cornerRadius: radius, color: borderColor, borderWith: borderWith)
        ProjectCommon.boundView(button: startMinutesButton, cornerRadius: radius, color: borderColor, borderWith: borderWith)
        ProjectCommon.boundView(button: endHoursButton, cornerRadius: radius, color: borderColor, borderWith: borderWith)
        ProjectCommon.boundView(button: endMinutesButton, cornerRadius: radius, color: borderColor, borderWith: borderWith)
    }
    
    func setupCell(object:CalendarTimeObject) -> Void {
        let startTime = object.start_time
        if startTime != "" {
            let startArr = startTime?.components(separatedBy: ":")
            startHourButton.setTitle(startArr?[0], for: UIControlState.normal)
            startMinutesButton.setTitle(startArr?[1], for: UIControlState.normal)
        }else {
            startHourButton.setTitle("00", for: UIControlState.normal)
            startMinutesButton.setTitle("00", for: UIControlState.normal)
        }
        let endTime = object.end_time
        if endTime != "" {
            let endArr = endTime?.components(separatedBy: ":")
            endHoursButton.setTitle(endArr?[0], for: UIControlState.normal)
            endMinutesButton.setTitle(endArr?[1], for: UIControlState.normal)
        }else {
            endHoursButton.setTitle("00", for: UIControlState.normal)
            endMinutesButton.setTitle("00", for: UIControlState.normal)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func tappedDeleteButton(_ sender: Any) {
        self.delegate?.deleteCalendar(cell: self)
    }
    @IBAction func tappedButtonTime(_ sender: Any) {
        let button = sender as! UIButton
        self.delegate?.selectTime(cell: self,buttonTag: button.tag)
    }
    

}
