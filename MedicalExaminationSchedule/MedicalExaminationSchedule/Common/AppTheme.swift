//
//  AppTheme.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class AppTheme: NSObject {

    static func color(withRGBA RGBA: UInt) -> UIColor {
        return UIColor(red: CGFloat((RGBA & 0xFF000000) >> 24) / 255.0,
                       green: CGFloat((RGBA & 0x00FF0000) >> 16) / 255.0,
                       blue: CGFloat((RGBA & 0x0000FF00) >> 8) / 255.0,
                       alpha: CGFloat(RGBA & 0x000000FF) / 255.0)
    }
    
    static func color(withRGB RGB: UInt) -> UIColor {
        return UIColor(red: CGFloat((RGB & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((RGB & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(RGB & 0x0000FF) / 255.0,
                       alpha: 1.0)
    }
    
    static func greenColor() -> UIColor {
        return self.color(withRGB: 0x3C80D1)
    }
}
