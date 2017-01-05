//
//  NewsModel.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/19/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class NewsModel: NSObject {
    var news_id : String?
    var news_title : String?
    var news_desciption : String?
    var news_author : String?
    var last_updated : String?
    var like_count : Int?
    var news_tags : Array<Any>?
    var news_url : String?
    
    init(dict:[String:AnyObject]) {
        if let v = dict["news_id"] {
            self.news_id = "\(v)"
        }else {
            self.news_id = ""
        }
        if let v = dict["news_title"] {
            self.news_title = "\(v)"
        }else {
            self.news_title = ""
        }
        if let v = dict["news_desciption"] {
            self.news_desciption = "\(v)"
        }else {
            self.news_desciption = ""
        }
        if let v = dict["news_author"] {
            self.news_author = "\(v)"
        }else {
            self.news_author = ""
        }
        if let v = dict["last_updated"] {
            self.last_updated = ProjectCommon.convertDateFromServer(string: v as! String)
        }else {
            self.last_updated = ""
        }
        if let v = dict["like_count"] {
            self.like_count = v as? Int
        }else {
            self.like_count = 0
        }
        if let v = dict["news_tags"] {
            self.news_tags = v as? Array
        }else {
            self.news_tags = []
        }
        if let v = dict["image_url"] {
            if v as! NSObject == NSNull() {
                self.news_url = ""
            } else {
                self.news_url = "\(v)"
            }
        }else {
            self.news_url = ""
        }
    }
    
}
