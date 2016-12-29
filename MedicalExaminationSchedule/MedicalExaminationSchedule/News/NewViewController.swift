//
//  NewViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, NewTableViewCellDelegate, DetailNewControllerDelegate {

    @IBOutlet weak var searchView: UIView!
//    @IBOutlet weak var searchTextField: UITextField!
//    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var newTableView: UITableView!
    var newsArray = [NewsModel]()
    var filterArray = [NewsModel]()
    
    var page_max = 1
    var currentNewsObject : NewsModel?
    var currentIndexPath : IndexPath?
    var searchActive : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        newTableView.rowHeight = UITableViewAutomaticDimension;
        newTableView.estimatedRowHeight = 400.0;
        self.getListNew(page_index: 0)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        view.backgroundColor = UIColor.blue
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
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: NEWS, parameters: dictParam, onCompletion: {(response) in
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
                    self.page_max = resultData["count"] as! Int
                    let listItem = resultData["items"] as! [AnyObject]
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = NewsModel.init(dict: item)
                        self.newsArray += [newsObject]
                    }
                    self.newTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func getListNew(page_index:Int) -> Void {
        
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String.init(format: "%d", page_index)
        dictParam["query"] = "test"
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: NEWS, parameters: dictParam, onCompletion: {(response) in
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
                    self.page_max = resultData["count"] as! Int
                    let listItem = resultData["items"] as! [AnyObject]
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = NewsModel.init(dict: item)
                        self.newsArray += [newsObject]
                    }
                    self.newTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    @IBAction func tappedSearchButton(_ sender: Any) {
    }
    
    /*
     =================== TABLEVIEW DATA SOURCE, DELEGATE =================
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filterArray.count
        }
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strIdentifer = "NewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! NewTableViewCell
        cell.delegate = self
        let object : NewsModel?
        if searchActive {
            object = filterArray[indexPath.row]
        }else {
            object = newsArray[indexPath.row]
        }
        cell.setupCell(object: object!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive {
            currentNewsObject = filterArray[indexPath.row]
        }else {
            currentNewsObject = newsArray[indexPath.row]
        }
        
        currentIndexPath = indexPath
        self.performSegue(withIdentifier: "pushToNewDetail", sender: self)
    }
    
    func likeAction(button:NewTableViewCell) {
        let indexPath = newTableView.indexPath(for: button)
        let newsObiect = newsArray[(indexPath?.row)!]
        
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObiect.news_id
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.postDataToURL(url: NEWS_LIKE, parameters: dictParam, onCompletion: {(response) in
            LoadingOverlay.shared.hideOverlayView()
            print(response)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText.lowercased()
        filterArray = newsArray.filter({ (object : NewsModel) -> Bool in
            let categoryMatch = (object.description.lowercased().contains(searchString)) || (object.news_title?.lowercased().contains(searchString))!
            return categoryMatch
        })
        if(filterArray.count == 0 && searchString == ""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        newTableView.reloadData()
    }
    
}
