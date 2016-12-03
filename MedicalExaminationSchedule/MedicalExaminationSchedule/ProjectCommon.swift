//
//  ProjectCommon.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ProjectCommon: NSObject {
    class func boundView(button:UIView) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.init(colorLiteralRed: 52/255.0, green: 126/255.0, blue: 214/255.0, alpha: 1).cgColor
    }
}
