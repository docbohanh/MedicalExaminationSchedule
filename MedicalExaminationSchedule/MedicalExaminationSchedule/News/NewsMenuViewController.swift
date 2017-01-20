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
    var tagArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let headerView = Bundle.main.loadNibNamed("TagHeaderView", owner: self, options: nil)?.first as! TagHeaderView
        tableview.tableHeaderView = headerView
        // Do any additional setup after loading the view.
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
            cell.tagLabel.text = tagArray[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //selected tag for news
        //back to news page
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
