//
//  AlarmListViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/2/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class AlarmListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: UIView!
    var alarmListArray = [ScheduleModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func tappedAddNewAlarm(_ sender: UIButton) {
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let scheduleObject = alarmListArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecurringScheduleTableViewCell") as! RecurringScheduleTableViewCell
        
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
