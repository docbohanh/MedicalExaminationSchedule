//
//  NewsMenuViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 1/19/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class NewsMenuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    
    @IBOutlet weak var tableview: UITableView!
    var tagArray = [[String:AnyObject]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
            let headerView = Bundle.main.loadNibNamed("TagHeaderView", owner: self, options: nil)?.first as! TagHeaderView
            tableview.tableHeaderView = headerView
        if tagArray.count == 0 {
            DispatchQueue.global().async {
                self.getNewsTagList(page_index: 0)
            }
        }
    }
    
    func getNewsTagList(page_index:Int) {
        var parameter = [String:String]()
        if UserDefaults.standard.object(forKey:"token_id") != nil {
            parameter["token_id"] = UserDefaults.standard.object(forKey:"token_id") as! String?
            parameter["page_index"] = String(page_index)
            APIManager.sharedInstance.getDataToURL(url: TAG, parameters: parameter, onCompletion:{response in
                    if response.result != nil {
                        if let value = response.result.value as? [String:AnyObject] {
                            if let result = value["result"] as? [String:AnyObject] {
                                if let items = result["items"] as? [AnyObject]{
                                    self.tagArray = items as! [[String:AnyObject]]
                                    DispatchQueue.main.async {
                                        self.tableview.reloadData()
                                    }
                                }
                            }
                        }
                    }
            })
        }
    }
    
    func loadNews(withTag tag:String,page_index:Int) {
        var parameter = [String:String]()
        if UserDefaults.standard.object(forKey:"token_id") != nil {
            parameter["token_id"] = UserDefaults.standard.object(forKey:"token_id") as! String?
            parameter["page_index"] = String(page_index)
            parameter["tag"] = tag
            APIManager.sharedInstance.getDataToURL(url: NEWS_TAG, parameters: parameter, onCompletion:{response in
                if response.result != nil {
                    if let value = response.result.value as? [String:AnyObject] {
                        if let result = value["result"] as? [String:AnyObject] {
                            if let items = result["items"] as? [AnyObject]{
                                print("so item:\(items.count)")
                                DispatchQueue.main.async {
                                    if let drawerController = self.parent as? KYDrawerController {
                                        let newsViewController = drawerController.mainViewController as? NewViewController
                                        newsViewController?.newsArray.removeAll()
                                        for i in 0..<items.count {
                                            let item = items[i] as! [String:AnyObject]
                                            let newsObject = NewsModel.init(dict: item)
                                            newsViewController?.newsArray += [newsObject]
                                        }
                                        drawerController.setDrawerState(.closed, animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    LoadingOverlay.shared.hideOverlayView()
                }
            })
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "NewsTagTableViewCell", for: indexPath) as! NewsTagTableViewCell
        if tagArray.count > indexPath.row {
            let tagDictionary = tagArray[indexPath.row]
            if tagDictionary["name"] != nil {
                cell.tagLabel.text = tagDictionary["name"] as! String?
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tagObject = tagArray[indexPath.row]
        if tagObject["id"] != nil {
            LoadingOverlay.shared.showOverlay(view:view)
            DispatchQueue.global().async {
                self.loadNews(withTag: tagObject["name"] as! String, page_index: 0)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
