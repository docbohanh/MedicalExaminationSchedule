//
//  TimerFreeViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class TimerFreeViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var setupTimerButton: UIButton!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    @IBOutlet weak var specialLabel: UILabel!
    
    var serviceObject : ServiceModel?
    var selectedDate : Date?
    var timeArray = [CalendarTimeObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ProjectCommon.boundView(button: setupTimerButton)
        // Do any additional setup after loading the view.
        dateLabel.text = ProjectCommon.convertDateToString(date: selectedDate!)
        serviceNameLabel.text = serviceObject?.name
        specialLabel.text = serviceObject?.field
        self.getCalendarTime()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    @IBAction func tappedSetupTimer(_ sender: UIButton) {

        if timeArray.count > 0 {
            self.bookCalendar(object: timeArray[timePickerView.selectedRow(inComponent: 0)])
        }
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let object = timeArray[row]
        return String.init(format: "%@ - %@", object.start_time!, object.end_time!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* ============== API =============== */
    func getCalendarTime() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = serviceObject?.service_id
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể lấy thông tin lịch làm việc lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    var tempArray = [CalendarTimeObject]()
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = CalendarTimeObject.init(dict: item)
                        tempArray += [newsObject]
                    }
                    if self.timeArray.count > 0 {
                        self.timeArray.removeAll()
                    }
                    self.timeArray += tempArray
                    
                    self.timePickerView.reloadAllComponents()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể lấy thông tin lịch làm việc lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    })
                }
            }
        })
    }

    func bookCalendar(object:CalendarTimeObject) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = serviceObject?.service_id
        dictParam["description"] = ""
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        dictParam["start_time"] = object.start_time
        dictParam["end_time"] = object.end_time
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: CALENDAR_BOOK, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể lấy thông tin lịch làm việc lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    _ = self.navigationController?.popViewController(animated: true)
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể lấy thông tin lịch làm việc lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })

    }
    
}
