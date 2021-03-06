//
//  NewViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTableViewCellDelegate, DetailNewControllerDelegate,CLLocationManagerDelegate, UITextFieldDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var newTableView: UITableView!
    @IBOutlet weak var menuButton: UIButton!
    var newsArray = [NewsModel]()
    var filterArray = [NewsModel]()
    
    var page_max = 1
    var currentNewsObject : NewsModel?
    var currentIndexPath : IndexPath?
    var refreshControl : UIRefreshControl?
    var pageIndex = 0
    var locationManager = CLLocationManager()
    var queryString = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        self.getCurrentLocation()
        newTableView.rowHeight = UITableViewAutomaticDimension;
        newTableView.estimatedRowHeight = 400.0;
        self.getListNew(page_index: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
       weak var weakSelf = self
        
        // PullToRefresh
        refreshControl = ProjectCommon.addPullRefreshControl(newTableView, actionHandler: {
            weakSelf?.pageIndex = 0
            if self.newsArray.count > 0 {
                self.newsArray.removeAll()
            }
            self.newTableView.reloadData()
            weakSelf?.getListNew(page_index: (weakSelf?.pageIndex)!)
        })
    }
    
    @IBAction func tappedRevealToggle(_ sender: UIButton) {
        if let drawerController = self.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        view.backgroundColor = UIColor.blue
        newTableView.reloadData()
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pushToNewDetail" {
            let detailVC = segue.destination as! DetailNewViewController
            detailVC.newsObject = currentNewsObject
        }
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func getListLiked(page_index:Int) -> Void { // DONT USE
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String.init(format: "%d", page_index)
        dictParam["query"] = "test"
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: NEWS, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy tin tức,vui lòng chờ đợi trong ít phút", buttonArray: ["Đóng"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    self.page_max = resultData["count"] as! Int
                    let listItem = resultData["items"] as! [AnyObject]
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = NewsModel.init(dict: item)
                        self.newsArray += [newsObject]
                    }
                    self.newTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy tin tức,vui lòng chờ đợi trong ít phút", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func getListNew(page_index:Int) -> Void {
        
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String(pageIndex)
        dictParam["query"] = queryString
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: NEWS, parameters: dictParam, onCompletion: {(response) in
            print(response)
            ProjectCommon.stopAnimationRefresh()
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy tin tức,vui lòng chờ đợi trong ít phút", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    self.page_max = resultData["count"] as! Int
                    let listItem = resultData["items"] as! [AnyObject]
                    if listItem.count > 0 {
                        for i in 0..<listItem.count {
                            let item = listItem[i] as! [String:AnyObject]
                            let newsObject = NewsModel.init(dict: item)
                            self.newsArray += [newsObject]
                        }
                        self.newTableView.reloadData()
                        DispatchQueue.global().async {
                            self.loadMoreNews()
                        }
                    }
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy tin tức,vui lòng chờ đợi trong ít phút", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func loadMoreNews() {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String(pageIndex + 1)
        dictParam["query"] = queryString
        APIManager.sharedInstance.getDataToURL(url: NEWS, parameters: dictParam, onCompletion: {(response) in
            print(response)
            if (response.result.error != nil) {

            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    self.page_max = resultData["count"] as! Int
                    let listItem = resultData["items"] as! [AnyObject]
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = NewsModel.init(dict: item)
                        self.newsArray += [newsObject]
                    }
                    if listItem.count > 0 {
                        self.pageIndex = self.pageIndex + 1
                        self.loadMoreNews()
                    } else {
//                        self.newTableView.reloadData()
                    }
                }else {

                }
            }
        })
    }
    /*
     =================== TABLEVIEW DATA SOURCE, DELEGATE =================
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strIdentifer = "NewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! NewTableViewCell
        cell.delegate = self
        let object : NewsModel?
        if newsArray.count > indexPath.row {
            object = newsArray[indexPath.row]
            cell.setupCell(object: object!)
            if object?.news_url != "" {
                if object?.news_image == nil {
                    self.loadImage(url: (object?.news_url)!, indexPath: indexPath)
                }else {
                    cell.newImageView.image = object?.news_image
                }
                if cell.newImageView.image != nil {
                    let rate = (cell.newImageView.image?.size.height)!/(cell.newImageView.image?.size.width)!
                    cell.imageViewHeightConstraint.constant = cell.newImageView.frame.size.width * rate
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentNewsObject = newsArray[indexPath.row]
        currentIndexPath = indexPath
        self.performSegue(withIdentifier: "pushToNewDetail", sender: self)
    }
    
    func loadImage(url:String, indexPath:IndexPath) -> Void {
        let catPictureURL = URL(string: url)!
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: catPictureURL) { (data, response, error) in
            // The download has finished.
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = response as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        DispatchQueue.main.async {
                            let object = self.newsArray[indexPath.row] as NewsModel
                            object.news_image = UIImage(data: imageData)!
                            self.newTableView.beginUpdates()
                            self.newTableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                            self.newTableView.endUpdates()
                            self.view.layoutSubviews()
                            self.view.layoutIfNeeded()
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }

    
    func likeAction(button:NewTableViewCell) {
        let indexPath = newTableView.indexPath(for: button)
        let newsObiect = newsArray[(indexPath?.row)!]
        
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObiect.news_id
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: NEWS_LIKE, parameters: dictParam, onCompletion: {(response) in
            Lib.removeLoadingView(on: self.view)
            print(response)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message:"Đã xảy ra lỗi trong quá trình lấy tin tức,vui lòng chờ đợi trong ít phút", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy tin tức,vui lòng chờ đợi trong ít phút", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func shareAction(button: NewTableViewCell) {
       
    }

    func updateNews(newObject: NewsModel) {
        newsArray[(currentIndexPath?.row)!] = newObject
        newTableView.reloadData()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        let searchString = searchText.lowercased()
//        filterArray = newsArray.filter({ (object : NewsModel) -> Bool in
//            let categoryMatch = (object.description.lowercased().contains(searchString)) || (object.news_title?.lowercased().contains(searchString))!
//            return categoryMatch
//        })
//        if(filterArray.count == 0 && searchString == ""){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        newTableView.reloadData()
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var currentLocation = CLLocation()
        currentLocation = locations.last!
        
        UserDefaults.standard.set(String(currentLocation.coordinate.latitude), forKey: "latitude")
        UserDefaults.standard.set(String(currentLocation.coordinate.longitude), forKey: "longitude")
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("get location falure")
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if #available(iOS 9.0, *) {
            locationManager.requestLocation()
        } else {
            // Fallback on earlier versions
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

    @IBAction func tapped_searchButton(_ sender: Any) {
        if self.newsArray.count > 0 {
            self.newsArray.removeAll()
        }
        pageIndex = 0
        queryString = searchTextField.text!
        self.getListNew(page_index: pageIndex)
    }
    /* --------- TEXT FIELD DELEGATE --------------*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if self.newsArray.count > 0 {
            self.newsArray.removeAll()
        }
        pageIndex = 0
        queryString = textField.text!
        self.getListNew(page_index: pageIndex)
    }
}
