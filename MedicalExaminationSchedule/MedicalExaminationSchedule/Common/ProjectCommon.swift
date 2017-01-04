//
//  ProjectCommon.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

extension String {
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    var html2AttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
    
}

typealias AlertHandler = (Int) -> Void
typealias pullRefreshHandler = () -> Void

class ProjectCommon: NSObject {
    static var mRefreshControl : UIRefreshControl?
    static var mRefreshHandler : pullRefreshHandler?
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
    
    static func dateIsExpireDate(myDate:Date) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDateString = dateFormatter.string(from: myDate) as String
        let currentDate = Date()
        let currentDateString = dateFormatter.string(from: currentDate) as String
        if myDateString == currentDateString {
            return true
        }
        
        let result = currentDate.compare(myDate)
        if result == ComparisonResult.orderedAscending {
            return true
        }else {
            return false
        }
        
    }
    
    static func convertDateFromServer(string:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'.000Z'"
        let myDate = dateFormatter.date(from: string)
        if myDate == nil {
            return ""
        }
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: myDate!)
    }
    
    static func birthdayIsValidate(string:String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: string)
        let currentDate = Date()
        let result = currentDate.compare(myDate!)
        if result == ComparisonResult.orderedDescending {
            return true
        }else {
            return false
        }
    }
    
    static func addPullRefreshControl(_ view: UIScrollView, actionHandler: @escaping pullRefreshHandler) -> UIRefreshControl {
//        if (mRefreshControl != nil) {
        mRefreshControl?.removeFromSuperview()
            mRefreshHandler = actionHandler
            mRefreshControl = UIRefreshControl()
//            mRefreshControl.tintColor = kPinkColor
            mRefreshControl?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            mRefreshControl?.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
            view.addSubview(mRefreshControl!)
//        }
        return mRefreshControl!
    }
    
    static func refresh() {
        mRefreshHandler!()
    }
    
    static func stopAnimationRefresh() {
        mRefreshControl?.perform(#selector(mRefreshControl?.endRefreshing), with: nil, afterDelay: 0.5)
    }
    
}
