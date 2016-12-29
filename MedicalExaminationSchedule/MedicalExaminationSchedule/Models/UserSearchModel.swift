//
//  UserSearchModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/29/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UserSearchModel: NSObject {
    var name : String?
    var url : String?
    var email : String?
    var isSelected : Bool = false
    
    init(dict:[String:AnyObject]) {
        if let v = dict["url"] {
            self.url = "\(v)"
        }else {
            self.url = ""
        }
        if let v = dict["name"] {
            self.name = "\(v)"
        }else {
            self.name = ""
        }
        if let v = dict["email"] {
            self.email = "\(v)"
        }else {
            self.email = ""
        }
    }
}
