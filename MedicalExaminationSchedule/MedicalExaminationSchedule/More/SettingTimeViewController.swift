//
//  SettingTimeViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SettingTimeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SetupTimeCellDelegate {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var selectTimePopup : SelectTimeView?
    
    var selectedDate : Date?
    var isStarTime = false
    var timeArray = [CalendarTimeObject]()
    var currenIndexPath : IndexPath?
    var updateArray = [CalendarTimeObject]()
    var tempArray = [CalendarTimeObject]()
    var isLastObjectUpdate = false
    var service_id : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.text = ProjectCommon.convertDateToString(date: selectedDate!)
        // Do any additional setup after loading the view.
        self.getCalendarTime()
        self.initPopupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initPopupView() -> Void {
        selectTimePopup = UINib(nibName: "SelectTimeView", bundle: Bundle.main).instantiate(withOwner: self, options: nil)[0] as? SelectTimeView
        selectTimePopup?.frame = CGRect.init(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        selectTimePopup?.setupView(saveAction: { (timeString) in
            
            let object = self.timeArray[(self.currenIndexPath?.row)!] as CalendarTimeObject
            if self.isStarTime {
                object.start_time = timeString
            }else {
                object.end_time = timeString
            }
            let startMinutes = self.calculateMinute(string: object.start_time!)
            let endMinutes = self.calculateMinute(string: object.end_time!)
            if endMinutes > startMinutes || self.isStarTime {
                self.selectTimePopup?.isHidden = true
                self.tableView.reloadRows(at: [self.currenIndexPath!], with: UITableViewRowAnimation.none)
            }else {
                ProjectCommon.initAlertView(viewController: self, title: "Lỗi", message: "Giờ kết thúc phải lớn hơn giờ bắt đầu", buttonArray: ["OK"], onCompletion: { (index) in
                })
            }
  
        }, closeAction: { 
            self.selectTimePopup?.isHidden = true
        })
        navigationController?.view.addSubview(selectTimePopup!)
        selectTimePopup?.isHidden = true
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedAddButton(_ sender: Any) {
        let objecNew = CalendarTimeObject.init(dict: ["":"" as AnyObject])
        objecNew.start_time = "0:0"
        objecNew.end_time = "0:0"
        timeArray.append(objecNew)
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath.init(row: timeArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    @IBAction func tappedUpdateButton(_ sender: Any) {
        self.calculateMinute()
        self.deleteAllCalendarDate()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupTimeTableViewCell", for: indexPath) as! SetupTimeTableViewCell
        let object = timeArray[indexPath.row]
        cell.setupCell(object: object)
        cell.delegate = self
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    /* ============== API =============== */
    func getCalendarTime() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = service_id
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
             Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
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
                    
                    self.tableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
    }
    
    func postCalendarTime(object:CalendarTimeObject) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        dictParam["start_time"] = object.start_time
        dictParam["end_time"] = object.end_time
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    if self.isLastObjectUpdate {
                        self.calendarBookUpdate()
                        self.getCalendarTime()
                    }
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }

    func deleteCalendarTime(object:CalendarTimeObject) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        dictParam["start_time"] = object.start_time
        dictParam["end_time"] = object.end_time
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.deleteDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
             Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data get all again
                    self.calendarBookUpdate()
                     self.getCalendarTime()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func deleteAllCalendarDate() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.deleteDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // add new object
                    self.updateAllCalendar()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func calendarBookUpdate() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        
//        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: CALENDAR_BOOK_UPDATE, parameters: dictParam, onCompletion: {(response) in
            print(response)
//            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // add new object
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func deleteCalendar(cell: SetupTimeTableViewCell) {
        currenIndexPath = tableView.indexPath(for: cell)
        let object = timeArray[(currenIndexPath?.row)!]
        self.deleteCalendarTime(object: object)
    }
    
    func selectTime(cell: SetupTimeTableViewCell, buttonTag: Int) {
        currenIndexPath = tableView.indexPath(for: cell)
        var hours = cell.startHourButton.titleLabel?.text
        var minutes = cell.startMinutesButton.titleLabel?.text
        if buttonTag < 20 {
            // start
            isStarTime = true
        } else {
            // end
            isStarTime = false
            hours = cell.endHoursButton.titleLabel?.text
            minutes = cell.endMinutesButton.titleLabel?.text
        }
        selectTimePopup?.isHidden = false
        selectTimePopup?.showPop(hours: hours!, minutes: minutes!)
    }
    
    func calculateMinute() -> Void {
        if updateArray.count > 0 {
            updateArray.removeAll()
        }
        if tempArray.count > 0 {
            tempArray.removeAll()
        }
        for i in 0..<timeArray.count {
            var preObject = timeArray[i]
            for j in 0..<timeArray.count - 1 {
                let lastObject = timeArray[j]
                let preMin = self.calculateMinute(string: preObject.start_time!)
                let lastMin = self.calculateMinute(string: lastObject.start_time!)
                if preMin > lastMin {
                    preObject = lastObject
                }
            }
            tempArray.append(preObject)
        }
        
        for i in 0..<tempArray.count {
            let object = tempArray[i]
            if i == 0 {
                updateArray.append(object)
            }else {
                if object.start_time != "" && object.end_time != "" {
                    let lastObject = updateArray.last
                    let lastMinutes = self.calculateMinute(string: (lastObject?.end_time)!)
                    let startNewMinutes = self.calculateMinute(string: object.start_time!)
                    let endNewMinutes = self.calculateMinute(string: object.end_time!)
                    if lastMinutes > startNewMinutes {
                        if lastMinutes > endNewMinutes {
                            continue
                        }else {
                            lastObject?.end_time = object.end_time
                        }
                    } else {
                        updateArray.append(object)
                    }
                }
            }
        }
    }

    func calculateMinute(string:String) -> Int {
        var array = string.components(separatedBy: ":")
        let hours = Int(array[0])!
        let minutes = Int(array[1])!
        return hours*60 + minutes
    }
    
    func updateAllCalendar() -> Void {
        isLastObjectUpdate = false
        while updateArray.count > 0 {
            if updateArray.count == 1 {
                isLastObjectUpdate = true
            }
            let object = updateArray[0] as CalendarTimeObject
            self.postCalendarTime(object: object)
            updateArray .removeFirst()
        }
    }
}
