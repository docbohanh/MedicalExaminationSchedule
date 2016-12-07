//
//  setupTimeScheduleViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class setupTimeScheduleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var scheduleListTableView: UITableView!
    var scheduleListArray: [[String : String]] = [["one":"gala"],["dinner":"dinner"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupTimerTableViewCell", for: indexPath) as! SetupTimerTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = Bundle.main.loadNibNamed("SetupTimerHeaderView", owner: self, options: nil)?.first as! SetupTimerHeaderView
        return footerView
    }
    
    @IBAction func tappedAddNewTimer(_ sender: UIButton) {
        scheduleListArray.append(["mcLab":"mcLab"])
        scheduleListTableView.reloadData()
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
