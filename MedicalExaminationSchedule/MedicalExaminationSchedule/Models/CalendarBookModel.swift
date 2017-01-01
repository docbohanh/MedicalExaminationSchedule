//
//  CalendarBookModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

/*
 {
 "book_id": "0000000037",
 "service_id": 58,
 "service_name": "Hello Service",
 "user_id": 228,
 "user_name": "Tien Nguyen",
 "description": "",
 "start_time": "6:0",
 "end_time": "6:15",
 "status": "OK",
 "location": "Số 5 -  đường Giải phóng - Hoàng Mai - Hà nội",
 "book_time": "2016-12-29T09:48:15.000Z"
 },
 */

class CalendarBookModel: NSObject {
    
    var book_id : String?
    var service_id : String?
    var service_name : String?
    var user_id : String?
    var user_name : String?
    var description_book : String?
    var start_time : String?
    var end_time : String?
    var status : String?
    var location : String?
    var book_time : String?
    
    init(dict:[String:AnyObject]) {
        if let v = dict["book_id"] {
            self.book_id = "\(v)"
        }else {
            self.book_id = ""
        }
        if let v = dict["service_id"] {
            self.service_id = "\(v)"
        }else {
            self.service_id = ""
        }
        if let v = dict["service_name"] {
            self.service_name = "\(v)"
        }else {
            self.service_name = ""
        }
        if let v = dict["user_id"] {
            self.user_id = "\(v)"
        }else {
            self.user_id = ""
        }
        if let v = dict["user_name"] {
            self.user_name = "\(v)"
        }else {
            self.user_name = ""
        }
        if let v = dict["description"] {
            self.description_book = "\(v)"
        }else {
            self.description_book = ""
        }
        if let v = dict["start_time"] {
            self.start_time = "\(v)"
        }else {
            self.start_time = ""
        }
        if let v = dict["status"] {
            self.status = "\(v)"
        }else {
            self.status = ""
        }
        if let v = dict["location"] {
            self.location = "\(v)"
        }else {
            self.location = ""
        }
        if let v = dict["book_time"] {
            self.book_time = "\(v)"
            self.book_time = ProjectCommon.subStringDate(string: self.book_time!)
        }else {
            self.book_time = ""
        }
    }
}
