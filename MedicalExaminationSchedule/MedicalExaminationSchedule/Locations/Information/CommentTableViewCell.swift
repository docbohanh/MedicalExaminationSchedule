//
//  CommentTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var backgroundCommentImageView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLaber: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var startRateImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func initCell(object:CommentModel) -> Void {
        nameLabel.text = object.comment_title
        commentLabel.text = object.comment_content
        startRateImageView.image = UIImage.init(named: String.init(format: "ic_star_%d", object.rate!))
        timeLaber.text  = object.date_create
    }

}
