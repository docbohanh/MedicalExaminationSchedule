//
//  NewTableViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol NewTableViewCellDelegate {
    func likeAction(button:NewTableViewCell) -> Void
    func shareAction(button:NewTableViewCell) -> Void
}

class NewTableViewCell: UITableViewCell {

    @IBOutlet weak var lineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundCell: UIView!
    @IBOutlet weak var newImageView: UIImageView!
    @IBOutlet weak var newTitleLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    var delegate : NewTableViewCellDelegate?
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ProjectCommon.boundView(button: backgroundCell, cornerRadius: 0, color: UIColor.lightGray, borderWith: 0.5)
        lineHeightConstraint.constant = 0.5
    }
    
    func setupCell(object:NewsModel) -> Void {
        newTitleLabel.text = object.news_title
        detailLabel.text = object.news_desciption
        createTimeLabel.text = object.last_updated
        likeCountLabel.text = String(format: "%d", object.like_count!)
        
        if object.news_url != "" {
            newImageView.isHidden = false
            imageViewHeightConstraint.constant = 150
            newImageView.loadImage(url: (object.news_url)!)
        }else {
            newImageView.isHidden = true
            imageViewHeightConstraint.constant = 0
        }
    }

    @IBAction func tappedShareFacebookButton(_ sender: UIButton) {
        self.delegate?.shareAction(button: self)
    }
    @IBAction func tappedLikeFaceBookButton(_ sender: UIButton) {
        self.delegate?.likeAction(button: self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
