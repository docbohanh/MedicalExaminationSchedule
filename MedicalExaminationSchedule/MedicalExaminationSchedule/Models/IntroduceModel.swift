//
//  IntroduceModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/28/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class IntroduceModel: NSObject {
    var id : String?
    var name : String?
    var desc : String?
    var isChange : Bool = false
    
    init(dict:[String:AnyObject]) {
        if let v = dict["id"] {
            self.id = "\(v)"
        }else {
            self.id = ""
        }
        if let v = dict["name"] {
            self.name = "\(v)"
        }else {
            self.name = ""
        }
        if let v = dict["desc"] {
            self.desc = "\(v)"
        }else {
            self.desc = ""
        }
    }
}
