//
//  NewViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/3/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class NewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var newTableView: UITableView!
    var newsArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        newTableView.rowHeight = UITableViewAutomaticDimension;
        newTableView.estimatedRowHeight = 400.0;
        self.getListNew()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    func getListNew() -> Void {
        let alert = UIAlertController(title: "", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        var dictParam = [String : AnyObject]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as AnyObject?
        dictParam["page_index"] = "1" as AnyObject?
        dictParam["query"] = "" as AnyObject?
        APIManager.sharedInstance.makeHTTPGetRequest(path:REST_API_URL + NEWS_GET, param: dictParam, onCompletion: {(json, error) in
            print("json:", json)
            if (json["status"] as! NSNumber) == 1 {
                // success
            }else {
                // success
                alert.title = "Lỗi"
                alert.message = error?.description
                self.present(alert, animated: true, completion: nil)
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let strIdentifer = "NewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: strIdentifer, for: indexPath) as! NewTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "pushToNewDetail", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
