//
//  SetupIntroduceViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class SetupIntroduceViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, SetupIntroduceTableViewCellDelegate {

    @IBOutlet weak var isntroduceListTableView: UITableView!
    @IBOutlet weak var updateButton: UIButton!
    
    @IBOutlet weak var updateButtonBottomConstraint: NSLayoutConstraint!
    var introduceItemsArray = [IntroduceModel]()
    var userProfile : UserModel?
    var currentIndexPath : IndexPath?
    var isShowLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ProjectCommon.boundViewWithColor(button: updateButton, color: UIColor.clear)
        isntroduceListTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        self.getAllIntroduce()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification:NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            updateButtonBottomConstraint.constant = keyboardHeight
        }
    }
    
    func keyboardWillHidden(notification:NSNotification) {
        updateButtonBottomConstraint.constant = 15
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedAddNewInstroduce(_ sender: UIButton) {
        let newObj = IntroduceModel.init(dict: ["":"" as AnyObject])
        newObj.isChange = true
        introduceItemsArray.append(newObj)
        isntroduceListTableView.reloadData()
        isntroduceListTableView.scrollToRow(at: IndexPath.init(row: introduceItemsArray.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    @IBAction func tappedUpdateInstroduce(_ sender: Any) {
        view.endEditing(true)
        var array = [IntroduceModel]()
        for i in 0..<introduceItemsArray.count {
            let obj = introduceItemsArray[i] as IntroduceModel
            if obj.isChange == true && (obj.name != "" || obj.desc != "") {
                array.append(obj)
            }
        }
        while array.count > 0 {
            if (array.count == 1)
            {
                isShowLoading = true
            }else {
                isShowLoading = false
            }
            let object = array[0] as IntroduceModel
            if object.id != "" {
                // update
                self.updateIntroduceItem(item: object)
            }else {
                // new
                self.addNewIntrodule(item: object)
            }
            array .removeFirst()
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return introduceItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SetupIntroduceTableViewCell", for: indexPath) as! SetupIntroduceTableViewCell
        cell.setupCell(object: (introduceItemsArray[indexPath.row]), indexPath: indexPath)
        cell.titleTextField.delegate = self
        cell.titleTextField.tag = indexPath.row
        cell.descriptionTextView.delegate = self
        cell.descriptionTextView.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /* ------------------ CALL API ---------------- */
    func getAllIntroduce() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = userProfile?.service_id
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: SERVICE_DETAIL, parameters: dictParam, onCompletion: {(response) in
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
                    let listItem = resultData["contents"] as! [AnyObject]
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = IntroduceModel.init(dict: item) as IntroduceModel
                        self.introduceItemsArray += [newsObject]
                    }
                    self.isntroduceListTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
    }
    
    func addNewIntrodule(item:IntroduceModel) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = userProfile?.service_id
        dictParam["title"] = item.name
        dictParam["desc"] = item.desc
        if isShowLoading {
            LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        }
        APIManager.sharedInstance.postDataToURL(url: SERVICE_DETAIL, parameters: dictParam, onCompletion: {(response) in
            print(response)
            if self.isShowLoading {
                LoadingOverlay.shared.hideOverlayView()
            }
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // success
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
    }

    func updateIntroduceItem(item:IntroduceModel) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = userProfile?.service_id
        dictParam["id"] = item.id
        dictParam["title"] = item.name
        dictParam["desc"] = item.desc
        if isShowLoading {
            LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        }
        APIManager.sharedInstance.postDataToURL(url: SERVICE_DETAIL, parameters: dictParam, onCompletion: {(response) in
            print(response)
            if self.isShowLoading {
                LoadingOverlay.shared.hideOverlayView()
            }
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // success
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
    }
    
    func deleteIntroduceItem(item:IntroduceModel) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = userProfile?.service_id
        dictParam["id"] = item.id
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.deleteDataToURL(url: SERVICE_DETAIL, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // success
                    self.introduceItemsArray.remove(at: (self.currentIndexPath?.row)!)
                    self.isntroduceListTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })
    }
    
    /* ------------ CELL DELEGATE ----------- */
    func deleteItem(indexPath: IndexPath) {
        currentIndexPath = indexPath
        let item = introduceItemsArray[indexPath.row]
        if item.id != "" {
            self.deleteIntroduceItem(item: introduceItemsArray[indexPath.row])
            
        }else {
            introduceItemsArray.remove(at: indexPath.row)
            isntroduceListTableView.reloadData()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let object = introduceItemsArray[textField.tag] as IntroduceModel
        object.name = textField.text
        object.isChange = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let object = introduceItemsArray[textView.tag] as IntroduceModel
        object.desc = textView.text
        object.isChange = true
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
