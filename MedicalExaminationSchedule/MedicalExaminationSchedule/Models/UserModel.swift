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
    
    init(dict:[String:String]) {
        if (dict["birthday"] != nil) {
            self.birthday = dict["birthday"]
        }
        if (dict["email"] != nil) {
            self.email = dict["email"]
        }
        if (dict["home_address"] != nil) {
            self.home_address = dict["home_address"]
        }
        if (dict["job"] != nil) {
            self.job = dict["job"]
        }
        if (dict["phone"] != nil) {
            self.phone = dict["phone"]
        }
        if (dict["sex"] != nil) {
            self.sex = dict["sex"]
        }
        if (dict["social_id"] != nil) {
            self.social_id = dict["social_id"]
        }
        if (dict["social_type"] != nil) {
            self.social_type = dict["social_type"]
        }
        if (dict["status"] != nil) {
            self.status = dict["status"]
        }
        if (dict["user_display_name"] != nil) {
            self.user_display_name = dict["user_display_name"]
        }
        if (dict["user_id"] != nil) {
            self.user_id = dict["user_id"]
        }
        if (dict["user_type_id"] != nil) {
            self.user_type_id = dict["user_type_id"]
        }
        if (dict["work_address"] != nil) {
            self.work_address = dict["work_address"]
        }
    }
    
}
