//
//  ProjectCommon.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

typealias AlertHandler = (Int) -> Void
class ProjectCommon: NSObject {
    static func boundView(button:UIView) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = COLOR_COMMON.cgColor
    }
    
    static func boundViewWithColor(button:UIView, color: UIColor) {
        button.clipsToBounds = true
        button.layer.cornerRadius = button.frame.size.height/2;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
    }
    
    static func boundView(button: UIView,cornerRadius: CGFloat, color: UIColor, borderWith: CGFloat) -> Void {
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius;
        button.layer.borderWidth = 1.0
        button.layer.borderColor = color.cgColor
        button.layer.borderWidth = borderWith
    }

    
    static func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
    static func convertStringDate(string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: string)!
    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    static func initAlertView(viewController: UIViewController,title:String, message:String, buttonArray:[String],onCompletion : @escaping AlertHandler) {
        let alertCustomView = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for i in 0..<buttonArray.count {
            alertCustomView.addAction(UIAlertAction(title: buttonArray[i], style: UIAlertActionStyle.default, handler: {(alert:UIAlertAction) in
                onCompletion(i)
            }))
        }
        viewController.present(alertCustomView, animated: true, completion: nil)
    }

}
