//
//  MainAlarmListViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 2/20/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class MainAlarmListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var backgroundButton: UIButton!
    @IBOutlet weak var addNewAlarmView: UIView!
    @IBOutlet weak var noAlarmView: UIView!
    @IBOutlet weak var noAlarmImageView: UIImageView!
    @IBOutlet weak var addNewAlarmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelectionDuringEditing = true
        backgroundButton.alpha = 0.5
        // Do any additional setup after loading the view.
    }

    @IBAction func tappedBackground(_ sender: UIButton) {
        backgroundButton.isHidden = true
        addNewAlarmView.isHidden = true
        noAlarmView.isHidden = false
    }
    @IBAction func tappedAddNewLoop(_ sender: UIButton) {
        backgroundButton.isHidden = true
        addNewAlarmView.isHidden = true
        noAlarmView.isHidden = true    }
    @IBAction func tappedAddNewWeekDay(_ sender: UIButton) {
        backgroundButton.isHidden = true
        addNewAlarmView.isHidden = true
        noAlarmView.isHidden = true
    }
    
    @IBAction func tappedAddNewAlarm(_ sender: UIButton) {
        backgroundButton.isHidden = false
        addNewAlarmView.isHidden = false
        noAlarmView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Alarms.sharedInstance.count > 0 {
            noAlarmView.isHidden = true
        } else {
            noAlarmView.isHidden = false
        }
        tableView.reloadData()
        //dynamically append the edit button
        if Alarms.sharedInstance.count != 0
        {
            self.navigationItem.leftBarButtonItem = editButtonItem
            //self.navigationItem.leftBarButtonItem?.tintColor = UIColor.redColor()
        }
        else
        {
            self.navigationItem.leftBarButtonItem = nil
        }
        //unschedule all the notifications, faster than calling the cancelAllNotifications func
        UIApplication.shared.scheduledLocalNotifications = nil
        
        let cells = tableView.visibleCells
        if !cells.isEmpty
        {
            assert( cells.count==Alarms.sharedInstance.count, "alarms not been updated correctly")
            var count = cells.count
            while count>0
            {
                if Alarms.sharedInstance[count-1].enabled
                {
                    (cells[count-1].accessoryView as! UISwitch).setOn(true, animated: false)
                    cells[count-1].backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                }
                else
                {
                    (cells[count-1].accessoryView as! UISwitch).setOn(false, animated: false)
                    cells[count-1].backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
                }
                
                count -= 1
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if Alarms.sharedInstance.count == 0
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        }
        else
        {
            tableView.separatorStyle = UITableViewCellSeparatorStyle.singleLine
        }
        return Alarms.sharedInstance.count
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if isEditing
        {
            Global.indexOfCell = indexPath.row
            self.tableView.tag = indexPath.row
            performSegue(withIdentifier: "editSegue", sender: self)
        }
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTableViewCell", for: indexPath) as! AlarmTableViewCell
  
        cell.tag = indexPath.row
        let ala = Alarms.sharedInstance[indexPath.row] as Alarm
        cell.textLabel?.text = ala.timeStr
        cell.textLabel?.font = UIFont.systemFont(ofSize: 22.0)
        cell.detailTextLabel?.text = ala.label

        // Configure the cell...
        
        let sw = UISwitch(frame: CGRect())
        //sw.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
        //tag is used to indicate which row had been touched
        sw.tag = indexPath.row
        cell.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
        sw.addTarget(self, action: #selector(MainAlarmViewController.switchTapped(_:)), for: UIControlEvents.touchUpInside)
        if ala.enabled
        {
            sw.setOn(true, animated: false)
        }
        cell.accessoryView = sw
        
        
        //delete empty seperator line
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        return cell
    }
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Alarms.sharedInstance.removeAtIndex(indexPath.row)
            Alarms.sharedInstance.deleteAlarm(indexPath.row)
            let cells = tableView.visibleCells
            for cell in cells
            {
                let sw = cell.accessoryView as! UISwitch
                if sw.tag > indexPath.row
                {
                    sw.tag -= 1
                }
            }
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addSegue"
        {
            Global.isEditMode = false
            Global.label = "Alarm"
            Global.mediaLabel = "bell"
            Global.weekdays.removeAll(keepingCapacity: true)
            Global.snoozeEnabled = false
        }
        else if segue.identifier == "editSegue"
        {
            Global.isEditMode = true
            Global.weekdays = Alarms.sharedInstance[Global.indexOfCell].repeatWeekdays
            Global.label = Alarms.sharedInstance[Global.indexOfCell].label
            Global.mediaLabel = Alarms.sharedInstance[Global.indexOfCell].mediaLabel
            Global.snoozeEnabled = Alarms.sharedInstance[Global.indexOfCell].snoozeEnabled
        }
        
        
    }
    
    @IBAction func unwindToMainAlarmView(_ segue: UIStoryboardSegue) {
        isEditing = false
        Global.weekdays.removeAll(keepingCapacity: true)
        
    }
}
