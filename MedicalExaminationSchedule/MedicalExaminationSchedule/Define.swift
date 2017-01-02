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
let USER_LOGIN = "user/login"
let USER_LOGOUT = "user/logout"
let USER_REGISTER = "user/register"
let USER_FORGOT_REQUEST = "user/forgot_request"
let USER_FORGOT_CONFIRM = "user/forgot_confirm"
let USER_INFO = "user/info"
let USER_LOCATION = "user/location"
let USER_INVITE = "user/invite"
let USER_DOCTOR = "user/doctor"
let USER_LIST = "user/list"

let NEWS = "news"
let NEWS_CONTENT = "news/content"
let NEWS_TAG = "news/tag"
let NEWS_LIKE = "news/like"

let SERVICE = "service"
let SERVICE_DETAIL = "service/detail"
let SERVICE_USER = "service/user"


let COMMENT = "comment"

let CALENDAR_TIME = "calendar/time"
let CALENDAR_BOOK = "calendar/book"
let CALENDAR_BOOK_UPDATE = "calendar/book/update"


let IMAGE_SERVICE = "image/service"
let IMAGE_USER = "image/user"
let googleKey = "AIzaSyCupPZeGH2WyU6-NJbqIx9oxHdyYKH9iRs"

let TAG = "tag"
let UPDATE_PROFILE_SUCCESS = "UpdateProfileSuccessNotification"
let UPDATE_AVATAR_SUCCESS = "UpdateAvatarSuccessNotification"


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
























