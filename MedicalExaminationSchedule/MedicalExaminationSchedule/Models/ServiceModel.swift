//
//  ServiceModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/20/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ServiceModel: NSObject {
    var service_id : String?
    var name : String?
    var latitude : String?
    var longitude : String?
    var address : String?
    var corporation : String?
    var field : String?
    var tag: Int?
    
    init(dict:[String:AnyObject]) {
        if let v = dict["id"] {
            if v as! NSObject == NSNull() {
                self.service_id = ""
            } else {
                self.service_id = "\(v)"
            }
        }else {
            self.service_id = ""
        }
        if let v = dict["name"] {
            if v as! NSObject == NSNull() {
                self.name = ""
            } else {
                self.name = "\(v)"
            }
        }else {
            self.name = ""
        }
        if let v = dict["latitude"] {
            if v as! NSObject == NSNull() {
                self.latitude = ""
            } else {
                self.latitude = "\(v)"
            }
        }else {
            self.latitude = ""
        }
        if let v = dict["longitude"] {
            if v as! NSObject == NSNull() {
                self.longitude = ""
            } else {
                self.longitude = "\(v)"
            }
        }else {
            self.longitude = ""
        }
        if let v = dict["address"] {
            if v as! NSObject == NSNull() {
                self.address = ""
            } else {
                self.address = "\(v)"
            }
        }else {
            self.address = ""
        }
        if let v = dict["corporation"] {
            if v as! NSObject == NSNull() {
                self.corporation = ""
            } else {
                self.corporation = "\(v)"
            }
        }else {
            self.corporation = ""
        }
        if let v = dict["field"] {
            if v as! NSObject == NSNull() {
                self.field = ""
            } else {
                self.field = "\(v)"
            }
        }else {
            self.field = ""
        }
    }

}
