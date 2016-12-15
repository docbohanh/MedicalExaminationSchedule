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
    var user_type_id : String?
    var work_address : String?
    
    init(dict:[String:AnyObject]) {
        if (dict["birthday"] != nil) {
            self.birthday = dict["birthday"] as? String ?? ""
        }else {
            self.birthday = ""
        }
        if (dict["email"] != nil) {
            self.email = dict["email"] as? String
        }
        if (dict["home_address"] != nil) {
            self.home_address = dict["home_address"] as? String
        }
        if (dict["job"] != nil) {
            self.job = dict["job"] as? String
        }
        if (dict["phone"] != nil) {
            self.phone = dict["phone"] as? String
        }
        if (dict["sex"] != nil) {
            self.sex = dict["sex"] as? String
        }
        if (dict["social_id"] != nil) {
            self.social_id = dict["social_id"] as? String
        }
        if (dict["social_type"] != nil) {
            self.social_type = dict["social_type"] as? String
        }
        if (dict["status"] != nil) {
            self.status = dict["status"] as? String
        }
        if (dict["user_display_name"] != nil) {
            self.user_display_name = dict["user_display_name"] as? String
        }
        if (dict["user_id"] != nil) {
            self.user_id = dict["user_id"] as? String
        }
        if (dict["user_type_id"] != nil) {
            self.user_type_id = dict["user_type_id"] as? String
        }
        if (dict["work_address"] != nil) {
            self.work_address = dict["work_address"] as? String
        }
    }
    
}
