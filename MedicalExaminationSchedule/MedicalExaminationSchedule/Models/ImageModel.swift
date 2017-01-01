//
//  ImageModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 1/1/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ImageModel: NSObject {
    var id : String?
    var title : String?
    var desc : String?
    var url : String?
    var isSelected = false
    
    
    init(dict:[String:AnyObject]) {
        if let v = dict["id"] {
            self.id = "\(v)"
        }else {
            self.id = ""
        }
        if let v = dict["title"] {
            self.title = "\(v)"
        }else {
            self.title = ""
        }
        if let v = dict["desc"] {
            self.desc = "\(v)"
        }else {
            self.desc = ""
        }
        if let v = dict["url"] {
            self.url = "\(v)"
        }else {
            self.url = ""
        }
    }
}
