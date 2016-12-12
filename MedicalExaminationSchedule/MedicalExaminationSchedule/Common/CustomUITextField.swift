//
//  CustomUITextField.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/13/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect.init(x: bounds.origin.x + 15, y: 0, width: bounds.size.width, height: bounds.size.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return self.textRect(forBounds: bounds);
    }

}
