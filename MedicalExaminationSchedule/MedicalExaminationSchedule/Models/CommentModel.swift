//
//  CommentModel.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/21/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class CommentModel: NSObject {
    var comment_id : String?
    var comment_author_id : String?
    var comment_title : String?
    var comment_content : String?
    var rate : Int?
    var date_create : String?
    
    init(dict:[String:AnyObject]) {
        if let v = dict["comment_id"] {
            self.comment_id = "\(v)"
        }else {
            self.comment_id = ""
        }
        if let v = dict["comment_author_id"] {
            self.comment_author_id = "\(v)"
        }else {
            self.comment_author_id = ""
        }
        if let v = dict["comment_title"] {
            self.comment_title = "\(v)"
        }else {
            self.comment_title = ""
        }
        if let v = dict["comment_content"] {
            self.comment_content = "\(v)"
        }else {
            self.comment_content = ""
        }
        if let v = dict["rate"] {
            self.rate = v as? Int
        }else {
            self.rate = 0
        }
        if let v = dict["date_create"] {
            self.date_create = "\(v)"
        }else {
            self.date_create = ""
        }
    }
}
