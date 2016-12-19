//
//  NewViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewTableViewCellDelegate, DetailNewControllerDelegate {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var newTableView: UITableView!
    var newsArray = [NewsModel]()
    
    var page_max = 1
    var currentNewsObject : NewsModel?
    var currentIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        newTableView.rowHeight = UITableViewAutomaticDimension;
        newTableView.estimatedRowHeight = 400.0;
        self.getListNew(page_index: 0)
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
    
    
    func getListLiked(page_index:Int) -> Void { // DONT USE
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["page_index"] = String.init(format: "%d", page_index)
        dictParam["query"] = "test"
        LoadingOverlay.shared.showOverlay(view: self.view)
        APIManager.sharedInstance.getDataToURL(url: NEWS_GET, parameters: dictParam, onCompletion: {(response) in
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
        LoadingOverlay.shared.showOverlay(view: self.view)
        APIManager.sharedInstance.getDataToURL(url: NEWS_GET, parameters: dictParam, onCompletion: {(response) in
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
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strIdentifer = "NewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! NewTableViewCell
        cell.delegate = self
        cell.setupCell(object: newsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentNewsObject = newsArray[indexPath.row]
        currentIndexPath = indexPath
        self.performSegue(withIdentifier: "pushToNewDetail", sender: self)
    }
    
    func likeAction(button:NewTableViewCell) {
        let indexPath = newTableView.indexPath(for: button)
        let newsObiect = newsArray[(indexPath?.row)!]
        
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObiect.news_id
        LoadingOverlay.shared.showOverlay(view: view)
        APIManager.sharedInstance.postDataToURL(url: NEWS_POST_LIKE, parameters: dictParam, onCompletion: {(response) in
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
//        self.newTableView.reloadRows(at: [self.currentIndexPath!], with: UITableViewRowAnimation.none)
        newTableView.reloadData()
       
    }
    
}
