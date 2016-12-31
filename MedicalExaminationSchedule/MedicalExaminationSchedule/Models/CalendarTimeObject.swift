//
//  CalendarTimeObject.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class CalendarTimeObject: NSObject {
    var start_time : String?
    var end_time : String?
    var status : Bool = false
    
    init(dict:[String:AnyObject]) {
        if let v = dict["start_time"] {
            self.start_time = "\(v)"
        }else {
            self.start_time = ""
        }
        if let v = dict["end_time"] {
            self.end_time = "\(v)"
        }else {
            self.end_time = ""
        }
        if let v = dict["status"] {
            self.status = dict["status"] as! Bool
        }
    }
}
