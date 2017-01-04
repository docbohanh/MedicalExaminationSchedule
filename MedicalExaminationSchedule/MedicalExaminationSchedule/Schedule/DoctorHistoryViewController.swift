//
//  DoctorHistoryViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorHistoryViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var segmentBackgroundView: UIView!
    @IBOutlet weak var tabLineView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bookedTabButton: UIButton!
    @IBOutlet weak var endTabButton: UIButton!
    @IBOutlet weak var cancelTabButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var tabIndex = 0
    var bookCanceledArray = [CalendarBookModel]()
    var bookedArray = [CalendarBookModel]()
    var bookEndedArray = [CalendarBookModel]()
    var searchActive = false
    var filterArray = [CalendarBookModel]()
    var refreshControl : UIRefreshControl?
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        self.bookedTabSelected(bookedTabButton)
        
        // PullToRefresh
        weak var weakSelf = self
        refreshControl = ProjectCommon.addPullRefreshControl(tableView, actionHandler: {
            weakSelf?.pageIndex = 0
            if self.bookedArray.count > 0 {
                self.bookedArray.removeAll()
            }
            if self.bookEndedArray.count > 0 {
                self.bookEndedArray.removeAll()
            }
            if self.bookCanceledArray.count > 0 {
                self.bookCanceledArray.removeAll()
            }
            self.getAllBook()
        })
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllBook()
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func bookedTabSelected(_ sender: Any) {
        tabIndex = 0
        bookedTabButton.isSelected = true
        endTabButton.isSelected = false
        cancelTabButton.isSelected = false
        tabLineView.center = CGPoint.init(x: bookedTabButton.center.x, y: tabLineView.center.y)
        tableView.reloadData()
        self.resetSearchBar()
    }
    @IBAction func endTabSelected(_ sender: Any) {
        tabIndex = 1
        bookedTabButton.isSelected = false
        endTabButton.isSelected = true
        cancelTabButton.isSelected = false
        tabLineView.center = CGPoint.init(x: endTabButton.center.x, y: tabLineView.center.y)
        tableView.reloadData()
        self.resetSearchBar()
    }
    
    @IBAction func cancelTabSelected(_ sender: Any) {
        tabIndex = 2
        bookedTabButton.isSelected = false
        endTabButton.isSelected = false
        cancelTabButton.isSelected = true
        tabLineView.center = CGPoint.init(x: cancelTabButton.center.x, y: tabLineView.center.y)
        tableView.reloadData()
        self.resetSearchBar()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterArray.count
        } else {
            switch tabIndex {
            case 0:
                return bookedArray.count
            case 1:
                return bookEndedArray.count
            default:
                return bookCanceledArray.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorHistoryTableViewCell", for: indexPath) as! DoctorHistoryTableViewCell
        if searchActive {
            cell.initCell(object: filterArray[indexPath.row])
        }else {
            switch tabIndex {
            case 0:
                cell.initCell(object: bookedArray[indexPath.row])
                break
            case 1:
                cell.initCell(object: bookEndedArray[indexPath.row])
                break
            default:
                cell.initCell(object: bookCanceledArray[indexPath.row])
                break
                
            }
        }
        
        return cell
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /* ----------- API ------------- */
    func getAllBook() -> Void {
        var dictParam = [String : String]()
//        dictParam["token_id"] = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL2FwaS5tZWRodWIudm4vIiwiZW1haWwiOiJhYmMzQGdtYWlsLmNvbSIsImlkIjoiMDAwMDAwMDAyNDAiLCJ0eXBlIjoxLCJqdGkiOiIyMDQxYTkwZS0yZTExLTQ1OGQtYWE5Yy1mMWEzNTYxNDFhYjAiLCJpYXQiOjE0ODMwMjUwMDR9.WY2V75cvS1MgGQ3tV6NfaNWkoSxDCurDPxYpi_D-Vks"
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String(pageIndex)
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_BOOK, parameters: dictParam, onCompletion: {(response) in
            print(response)
            ProjectCommon.stopAnimationRefresh()
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy  lịch hẹn nào", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    if listItem.count > 0 {
                        for i in 0..<listItem.count {
                            let item = listItem[i] as! [String:AnyObject]
                            let newsObject = CalendarBookModel.init(dict: item)
                            
                            let dateToCompare = String.init(format: "%@ %@", newsObject.book_time!, newsObject.end_time!)
                            if ProjectCommon.isExpireDate(timeString: dateToCompare) {
                                self.bookEndedArray.append(newsObject)
                            }else{
                                if newsObject.status == "Đóng" {
                                    self.bookedArray.append(newsObject)
                                }else {
                                    self.bookCanceledArray.append(newsObject)
                                }
                            }
                        }
                        self.tableView.reloadData()
                        DispatchQueue.global().async {
                            self.loadMoreBook()
                        }
                    }else {
                        
                    }
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy lịch hẹn nào", buttonArray: ["Đóng"], onCompletion: { (index) in
                    })
                }
            }
        })
    }
    
    func loadMoreBook() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String(pageIndex+1)
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: CALENDAR_BOOK, parameters: dictParam, onCompletion: {(response) in
            print(response)
            ProjectCommon.stopAnimationRefresh()
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
//                ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy  lịch hẹn nào", buttonArray: ["Đóng"], onCompletion: { (index) in
//                    
//                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    if listItem.count > 0 {
                        self.pageIndex = self.pageIndex + 1
                        for i in 0..<listItem.count {
                            let item = listItem[i] as! [String:AnyObject]
                            let newsObject = CalendarBookModel.init(dict: item)
                            
                            let dateToCompare = String.init(format: "%@ %@", newsObject.book_time!, newsObject.end_time!)
                            if ProjectCommon.isExpireDate(timeString: dateToCompare) {
                                self.bookEndedArray.append(newsObject)
                            }else{
                                if newsObject.status == "Đóng" {
                                    self.bookedArray.append(newsObject)
                                }else {
                                    self.bookCanceledArray.append(newsObject)
                                }
                            }
                        }
                    }else {
                        self.tableView.reloadData()
                    }
                    
//                    self.tableView.reloadData()
                }else {
//                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không tìm thấy lịch hẹn nào", buttonArray: ["Đóng"], onCompletion: { (index) in
//                    })
                }
            }
        })
    }

    
    func resetSearchBar() -> Void {
        searchBar.text = ""
        searchActive = false
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText.lowercased()
        var array = [CalendarBookModel]()
        switch tabIndex {
        case 0:
            array = bookedArray
            break
        case 1:
            array = bookEndedArray
            break
        default:
            array = bookCanceledArray
            break
        }
        filterArray = array.filter({ (object : CalendarBookModel) -> Bool in
            let categoryMatch = (object.service_name?.lowercased().contains(searchString))! || (object.user_name?.lowercased().contains(searchString))!
            return categoryMatch
        })
        if(filterArray.count == 0 && searchString == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        tableView.reloadData()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
