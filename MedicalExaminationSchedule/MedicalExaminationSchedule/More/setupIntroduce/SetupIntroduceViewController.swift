//
//  SetupIntroduceViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SetupIntroduceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var isntroduceListTableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
        var scheduleListArray: [[String : String]] = [["one":"gala"],["dinner":"dinner"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ProjectCommon.boundViewWithColor(button: updateButton, color: UIColor.clear)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedAddNewInstroduce(_ sender: UIButton) {
        scheduleListArray.append(["mcLab":"mcLab"])
        isntroduceListTableView.reloadData()
    }
    
    @IBAction func tappedUpdateInstroduce(_ sender: Any) {
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scheduleListArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupIntroduceTableViewCell", for: indexPath) as! SetupIntroduceTableViewCell
        
        return cell
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
