//
//  ChangeAvatarView.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol ChangeAvatarViewDelegate {
    func closePopup() -> Void
    func takePhoto() -> Void
    func chooseFromLibrary() -> Void
    func deleteAvatar() -> Void
}

class ChangeAvatarView: UIView {

    var delegate : ChangeAvatarViewDelegate?
    
    @IBAction func tappedDeleteAvatar(_ sender: Any) {
        self.delegate?.deleteAvatar()
    }
    @IBAction func tappedCameraButton(_ sender: Any) {
        self.delegate?.takePhoto()
    }
    @IBAction func tappedChooseImageButton(_ sender: Any) {
        self.delegate?.chooseFromLibrary()
    }
    @IBAction func tappedClosePopupButton(_ sender: Any) {
        self.delegate?.closePopup()
    }
    
}
