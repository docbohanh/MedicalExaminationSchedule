//
//  UserModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/14/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UserModel: NSObject {
    var birthday : String?
    var email : String?
    var home_address : String?
    var job : String?
    var phone : String?
    var sex : String?
    var social_id : String?
    var social_type : String?
    var status : String?
    var user_display_name : String?
    var user_id : String?
    var user_type_id : Bool?
    var work_address : String?
    var list_sevice_id = [AnyObject]()
    var service_id : String?
    
    init(dict:[String:AnyObject]) {
        if let v = dict["birthday"] {
            self.birthday = "\(v)"
            self.birthday = ProjectCommon.subStringDate(string: self.birthday!)
        }else {
            self.birthday = ""
        }
        if let v = dict["email"] {
            self.email = "\(v)"
        } else {
            self.email = ""
        }
        if let v = dict["home_address"] {
            self.home_address = "\(v)"
        } else {
            self.home_address = ""
        }
        if let v = dict["job"] {
            self.job = "\(v)"
        } else {
            self.job = ""
        }
        if let v = dict["phone"] {
            self.phone = "\(v)"
        } else {
            self.phone = ""
        }
        if let v = dict["sex"] {
            self.sex = "\(v)"
        } else {
            self.sex = ""
        }
        if let v = dict["social_id"] {
            self.social_id = "\(v)"
        } else {
            self.social_id = ""
        }
        if let v = dict["social_type"] {
            self.social_type = "\(v)"
        } else {
            self.social_type = ""
        }
        if let v = dict["status"] {
            self.status = "\(v)"
        } else {
            self.status = ""
        }
        if let v = dict["user_display_name"] {
            self.user_display_name = "\(v)"
        } else {
            self.user_display_name = ""
        }
        if let v = dict["user_id"] {
            self.user_id = "\(v)"
        } else {
            self.user_id = ""
        }
        if let v = dict["user_type_id"] {
            self.user_type_id = v as? Bool
        } else {
            self.user_type_id = false
        }
        if let v = dict["work_address"] {
            self.work_address = "\(v)"
        } else {
            self.work_address = ""
        }
    }
    
}
