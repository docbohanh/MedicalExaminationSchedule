//
//  ProjectCommon.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ProjectCommon: NSObject {
    static func boundView(button:UIView) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = COLOR_COMMON.cgColor
    }
    static func boundWiewWithColor(button:UIView, color: UIColor) {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
    }
}
