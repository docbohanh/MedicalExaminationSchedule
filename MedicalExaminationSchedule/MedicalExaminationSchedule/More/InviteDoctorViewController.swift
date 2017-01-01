//
//  InviteDoctorViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class InviteDoctorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var searchtextField: UITextField!
    @IBOutlet weak var doctorListTableView: UITableView!
    @IBOutlet weak var inviteButton: UIButton!
    
    var userArray = [UserSearchModel]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ProjectCommon.boundViewWithColor(button: inviteButton, color: UIColor.clear)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @IBAction func tappedInviteDoctor(_ sender: UIButton) {
        view.endEditing(true)
        var array = [UserSearchModel]()
        for i in 0..<userArray.count {
            let obj = userArray[i] as UserSearchModel
            if obj.isSelected == true{
                array.append(obj)
            }
        }
        while array.count > 0 {
            let object = array[0] as UserSearchModel
            self.inviteUser(object: object)
            array .removeFirst()
        }
    }
    @IBAction func tappedSearch(_ sender: Any) {
        view.endEditing(true)
        if searchtextField.text == "" {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Hãy gõ từ khoá tìm kiếm", buttonArray: ["OK"], onCompletion: { (index) in
            })
        }
        self.getListUser(text: searchtextField.text!)
    }
    @IBAction func tappedBack(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteDoctorTableViewCell", for: indexPath) as! InviteDoctorTableViewCell
        cell.initCell(object: userArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = userArray[indexPath.row]
        object.isSelected = !object.isSelected
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func getListUser(text:String) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["text"] = text
        dictParam["page_index"] = "0"
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: USER_LIST, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    
                    let listItem = resultData["items"] as! [AnyObject]
                    var tempArray = [UserSearchModel]()
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = UserSearchModel.init(dict: item)
                        tempArray += [newsObject]
                    }
                    if self.userArray.count > 0 {
                        self.userArray.removeAll()
                    }
                    self.userArray += tempArray
                    self.doctorListTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
    }
    
    func inviteUser(object:UserSearchModel) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["email"] = object.email
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: USER_INVITE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
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
