//
//  ProjectCommon.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import Foundation
import UIKit

let COLOR_COMMON = UIColor.init(colorLiteralRed: 52/255.0, green: 126/255.0, blue: 214/255.0, alpha: 1)
let REST_API_URL = "https://api.medhub.vn/"
let USER_POST_LOGIN = "user/login"
let USER_POST_LOGOUT = "user/logout"
let USER_POST_REGISTER = "user/register"
let USER_POST_FORGOT_REQUEST = "user/forgot_request"
let USER_GET_FORGOT_CONFIRM = "user/forgot_confirm"
let USER_POST_INFO = "user/info"
let USER_GET_INFO = "user/info"
let USER_POST_LOCATION = "user/location"
let USER_POST_INVITE = "user/invite"
let USER_POST_DOCTOR = "user/doctor"

let NEWS_GET = "news"
let NEWS_POST = "news"
let NEWS_GET_CONTENT = "news/content"
let NEWS_GET_TAG = "news/tag"
let NEWS_GET_LIKE = "news/like"
let NEWS_POST_LIKE = "news/like"

let SERVCE_GET = "service"
let SERVICE_GET_DETAIL = "service/detail"
let SERVICE_POST_DETAIL = "service/detail"
let SERVICE_PUT_DETAIL = "service/detail"
let SERVICE_POST = "service"

let COMMENT_POST = "comment"
let COMMENT_GET = "comment"
let COMMENT_DELETE = "comment"

let CALENDAR_POST_TIME = "calendar/time"
let CALENDAR_GET_TIME = "calendar/time"
let CALENDAR_POST_BOOK = "calendar/book"
let CALENDAR_GET_BOOK = "calendar/book"
let CALENDAR_DELETE_BOOK = "calendar/book"

let IMAGE_POST_SERVICE = "image/service"
let IMAGE_GET_SERVICE = "image/service"
let IMAGE_DELETE_SERVICE = "image/service"
let IMAGE_POST_USER = "image/user"
let IMAGE_DELETE_USER = "image/user"
let IMAGE_GET_USER = "image/user"

let TAG_GET = "tag"
let TAG_POST = "tag"


// define enum key

enum USER_TYPE: String {
    case
        userTypeFacebook = "facebook"
    case
        userTypeGoogle = "google"
    case
        userTypeMedhub = "medhub"
};

enum USER_SEX:String {
    case
    userSexMale = "MALE"
    case
    userSexFemale = "FEMALE"
};























