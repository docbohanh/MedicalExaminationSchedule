//
//  ProfileTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol ProfileTableViewCellDelegate {
    func changeAvatar() -> Void
}
class ProfileTableViewCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    var delegate : ProfileTableViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.height/2
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 2.0
    }

    @IBAction func tappedEditAvatarButton(_ sender: Any) {
        self.delegate?.changeAvatar()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
