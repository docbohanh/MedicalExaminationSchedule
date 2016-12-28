//
//  SetupIntroduceTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol SetupIntroduceTableViewCellDelegate {
    func deleteItem(indexPath:IndexPath) -> Void
}

class SetupIntroduceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var removeInstroduceButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var delegate : SetupIntroduceTableViewCellDelegate?
    var cellIndexPath : IndexPath?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 3.0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func deleteItemButton_clicked(_ sender: Any) {
        self.delegate?.deleteItem(indexPath: cellIndexPath!)
    }

    func setupCell(object:IntroduceModel, indexPath:IndexPath) -> Void {
        titleTextField.text = object.name
        descriptionTextView.text = object.desc
        cellIndexPath = indexPath
    }
}
