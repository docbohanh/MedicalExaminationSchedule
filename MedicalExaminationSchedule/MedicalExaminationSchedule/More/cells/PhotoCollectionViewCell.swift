//
//  PhotoCollectionViewCell.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol PhotoCellDelegate {
    func selectedImage(cell:PhotoCollectionViewCell) -> Void
}

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var checkButton: UIButton!
    var delegate : PhotoCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func tappedCheckButton(_ sender: Any) {
        checkButton.isSelected = !checkButton.isSelected
        self.delegate?.selectedImage(cell: self)
    }

}
