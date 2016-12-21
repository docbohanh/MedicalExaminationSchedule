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
    
    init(dict:[String:AnyObject]) {
        if let v = dict["id"] {
            self.service_id = "\(v)"
        }else {
            self.service_id = ""
        }
        if let v = dict["name"] {
            self.name = "\(v)"
        }else {
            self.name = ""
        }
        if let v = dict["latitude"] {
            self.latitude = "\(v)"
        }else {
            self.latitude = ""
        }
        if let v = dict["longitude"] {
            self.longitude = "\(v)"
        }else {
            self.longitude = ""
        }
        if let v = dict["address"] {
            self.address = "\(v)"
        }else {
            self.address = ""
        }
        if let v = dict["corporation"] {
            self.corporation = "\(v)"
        }else {
            self.corporation = ""
        }
        if let v = dict["news_tags"] {
            self.field = "\(v)"
        }else {
            self.field = ""
        }
    }

}
