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
            self.selectTimePopup?.isHidden = true
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
        timeArray.append(CalendarTimeObject.init(dict: ["":"" as AnyObject]))
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath.init(row: timeArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
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
        dictParam["service_id"] = "29"
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
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
        
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
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

    func deleteCalendarTime(object:CalendarTimeObject) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["date"] = ProjectCommon.convertDateToString(date: selectedDate!)
        dictParam["start_time"] = object.start_time
        dictParam["end_time"] = object.end_time
        
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_TIME, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
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
    
    func deleteCalendar(cell: SetupTimeTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)! as IndexPath
        let object = timeArray[indexPath.row]
        self.deleteCalendarTime(object: object)
    }
    
    func selectTime(cell: SetupTimeTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)! as IndexPath
        let object = timeArray[indexPath.row]
        self.deleteCalendarTime(object: object)
    }
}
