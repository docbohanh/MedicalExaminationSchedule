//
//  SelectGenderTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol SelectGengerTableViewCellDelegate {
    
}

class SelectGenderTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ProjectCommon.boundView(button: maleButton)
        ProjectCommon.boundView(button: femaleButton)
        femaleButton.backgroundColor = UIColor.white
        femaleButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        maleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
    }
    @IBAction func tappedMaleButton(_ sender: Any) {
        femaleButton.backgroundColor = UIColor.white
        femaleButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        maleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        maleButton.backgroundColor = COLOR_COMMON
    }

    @IBAction func tappedFemaleButton(_ sender: Any) {
        femaleButton.backgroundColor = COLOR_COMMON
        femaleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        maleButton.setTitleColor(UIColor.lightGray, for: UIControlState.normal)
        maleButton.backgroundColor = UIColor.white
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
