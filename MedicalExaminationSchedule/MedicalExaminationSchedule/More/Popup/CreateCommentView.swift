//
//  CreateCommentView.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol CreateCommentViewDelegate {
    func closePopup() -> Void
    func sendComment(title:String,suggesstion:String) -> Void
}

class CreateCommentView : UIView,UITextFieldDelegate {
    var delegate : CreateCommentViewDelegate?
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var suggestionTitleTextField: UITextField!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        commentTextView.placeholder = "Góp ý của bạn về chúng tôi"
        commentTextView.clipsToBounds = true
        commentTextView.layer.cornerRadius = 5.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 0.5
        
        sendCommentButton.clipsToBounds = true
        sendCommentButton.layer.cornerRadius = 3.0
    }
    
    @IBAction func tappedSendCommentButton(_ sender: Any) {
        self.delegate?.sendComment(title: commentTextView.text ?? "", suggesstion: suggestionTitleTextField.text ?? "")
    }
    @IBAction func tappedCloseButtonComment(_ sender: Any) {
        self.delegate?.closePopup()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
