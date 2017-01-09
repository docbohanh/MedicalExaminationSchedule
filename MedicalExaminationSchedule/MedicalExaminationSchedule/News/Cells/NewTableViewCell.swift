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
//            imageViewHeightConstraint.constant = 150
//            self.loadImage(url: object.news_url!)
//            if self.newImageView.image != nil {
//                let rate = (self.newImageView.image?.size.height)!/(self.newImageView.image?.size.width)!
//                self.imageViewHeightConstraint.constant = self.newImageView.frame.size.width * rate
//                self.setNeedsLayout()
//                self.layoutSubviews()
//            }
//            newImageView.loadImage(url: (object.news_url)!)
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

    func loadImage(url:String) -> Void {
        let catPictureURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        DispatchQueue.main.async {
                            self.newImageView.image = UIImage(data: imageData)!
                            if self.newImageView.image != nil {
                                let rate = (self.newImageView.image?.size.height)!/(self.newImageView.image?.size.width)!
                                self.imageViewHeightConstraint.constant = self.newImageView.frame.size.width * rate
                                self.setNeedsLayout()
                                self.layoutSubviews()
                            }
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }

}
