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
        button.layer.borderWidth = 2.0
        button.layer.borderColor = self.color(withRGB: 0x3384e1, andAlpha: 70).cgColor
    }
    
    static func color(withRGB RGB: UInt, andAlpha alpha: Int) -> UIColor {
        return UIColor(red: CGFloat((RGB & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((RGB & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(RGB & 0x0000FF) / 255.0,
                       alpha: 1)
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
    
    static func subStringDate(string:String) -> String {
        var newString = string
        let index = newString.index(newString.startIndex, offsetBy: 10)
        if newString.characters.count > 10 {
            newString = newString.substring(to: index)
        }
        return newString
    }
    
    static func convertStringDate(string: String) -> Date {
        let newString = ProjectCommon.subStringDate(string: string)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: newString)!
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
    
    static func sha256(string: String) -> String? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        let shaHex =  digestData.map { String(format: "%02hhx", $0) }.joined()
        print(shaHex)
        
        return shaHex
    }
    
    static func showTimeTwoCharacter(time:String) -> String {
        if time.characters.count > 1 {
            return time
        }else {
            return String.init(format: "%@", time)
        }
    }
    
    static func isExpireDate(timeString:String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let myDate = dateFormatter.date(from: timeString)
        let currentDate = Date()
        let result = currentDate.compare(myDate!)
        if result == ComparisonResult.orderedDescending {
            return true
        }else {
            return false
        }
        
    }
}
