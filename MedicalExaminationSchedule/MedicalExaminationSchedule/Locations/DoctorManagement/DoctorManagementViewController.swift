//
//  DoctorManagementViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DoctorManagementViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITextViewDelegate{

    
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var backgroundScrollView: UIScrollView!
    @IBOutlet weak var backgroundInformationView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var doctorSpecializedLabel: UILabel!
    @IBOutlet weak var rateImageView: UIImageView!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var profileTabButton: UIButton!
    @IBOutlet weak var informationTabButton: UIButton!
    @IBOutlet weak var imageTabButton: UIButton!
    @IBOutlet weak var commentTabButton: UIButton!
    @IBOutlet weak var tabLineView: UIView!
    @IBOutlet weak var doctorHistoryLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var titleCommentTextField: UITextField!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    private weak var calendar: FSCalendar!
    let titleProfileArray = ["Họ tên","Địa chỉ","Giới tính","Chuyên nghành","Nơi làm việc"]
    var dataTestProfileArray = [String]()
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)

    var serviceObject : ServiceModel?
    var rate = 0
    var commentArray = [CommentModel]()
    
    
    @IBOutlet weak var informationTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initUI()
        self.fillData()
        imageCollectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        // Do any additional setup after loading the view.
        informationTableView.rowHeight = UITableViewAutomaticDimension;
        informationTableView.estimatedRowHeight = 200.0;
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = true
        view.addGestureRecognizer(tapGesture)
        
        self.getServiceDetail()
    }
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func initUI() {
        
        commentView.isHidden = true
        informationTableView.isHidden = true
        imageCollectionView.isHidden = true
        commentTextView.clipsToBounds = true
        commentTextView.layer.cornerRadius = 5.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.borderWidth = 1.0
        
        sendCommentButton.clipsToBounds = true
        sendCommentButton.layer.cornerRadius = 2.0
    }
    
    func fillData() -> Void {
        titleViewLabel.text = serviceObject?.name
        doctorSpecializedLabel.text = serviceObject?.field
        dataTestProfileArray += [(serviceObject?.name)!,(serviceObject?.address)!,"Nam",(serviceObject?.field)!, (serviceObject?.corporation)!]
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.origin.y + doctorHistoryLabel.frame.size.height + doctorHistoryLabel.frame.origin.y)
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCallDoctor(_ sender: UIButton) {
    }
    
    @IBAction func tappedSeeDoctorLocation(_ sender: Any) {
    }
    
    @IBAction func tappedDoctorProfile(_ sender: Any) {
        if doctorHistoryLabel.isHidden {
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: doctorHistoryLabel.frame.size.height + backgroundInformationView.frame.size.height)
            tabLineView.center = CGPoint.init(x: profileTabButton.center.x, y: tabLineView.center.y)
            doctorHistoryLabel.isHidden = false
            commentView.isHidden = true
            informationTableView.isHidden = true
            imageCollectionView.isHidden = true
        }
    }
    
    @IBAction func tappedDoctorInformation(_ sender: UIButton) {
        if informationTableView.isHidden {
            tabLineView.center = CGPoint.init(x: informationTabButton.center.x, y: tabLineView.center.y)
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundInformationView.frame.size.height + informationTableView.frame.size.height)
            
            backgroundScrollView.scrollRectToVisible(CGRect.init(x: informationTabButton.frame.origin.x, y: backgroundInformationView.frame.size.height - informationTabButton.frame.size.height, width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.size.height), animated: true)
            informationTableView.isHidden = false
            doctorHistoryLabel.isHidden = true
            commentView.isHidden = true
            imageCollectionView.isHidden = true
        }
    }
    
    @IBAction func tappedGetImageFromDevice(_ sender: UIButton) {
        if imageCollectionView.isHidden {
            tabLineView.center = CGPoint.init(x: imageTabButton.center.x, y: tabLineView.center.y)
            doctorHistoryLabel.isHidden = true
            informationTableView.isHidden = true
            commentView.isHidden = true
            imageCollectionView.isHidden = false
        }
    }
    @IBAction func tappedComment(_ sender: UIButton) {
        if commentView.isHidden {
            backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: sendCommentButton.frame.size.height + backgroundInformationView.frame.size.height)
            tabLineView.center = CGPoint.init(x: commentTabButton.center.x, y: tabLineView.center.y)
            doctorHistoryLabel.isHidden = true
            informationTableView.isHidden = true
            commentView.isHidden = false
            imageCollectionView.isHidden = true
        }
    }
    @IBAction func tappedSendComment(_ sender: UIButton) {
        // Send comment
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["service_id"] = serviceObject?.service_id
        dictParam["comment_content"] = commentTextView.text
        dictParam["comment_title"] = titleCommentTextField.text
        dictParam["rate"] = String.init(format: "%d", rate)
        LoadingOverlay.shared.showOverlay(view: self.view)
        APIManager.sharedInstance.postDataToURL(url: COMMENT_POST, parameters: dictParam, onCompletion: { (response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    let value = resultDictionary["result"] as! [String:AnyObject]
                    UserDefaults.standard.set(value["token_id"], forKey: "token_id")
                    self.performSegue(withIdentifier: "ShowTabBar", sender: self)
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })

    }
    
    @IBAction func tappedStarButton(_ sender: Any) {
        let button = sender as! UIButton
        let tag = button.tag
        rate = tag - 10
        for i in 10..<15 {
            let btn = view.viewWithTag(i) as! UIButton
            if i <= tag {
                btn.isSelected = true
            }else {
                btn.isSelected = false
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        if(text == "\n") {
//            textView.resignFirstResponder()
//            return false
//        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "setupScheduleOfUser" {
            let setupScheduleViewController = segue.destination as? SetupScheduleViewController
            setupScheduleViewController?.isDoctor = false
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
        return commentArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 220
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("RateHeaderView", owner: self, options: nil)?.first as! RateHeaderView
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DoctorProfileTableViewCell", for: indexPath) as! DoctorProfileTableViewCell
            if titleProfileArray.count > indexPath.row {
                cell.titleProfileLabel.text = titleProfileArray[indexPath.row]
                cell.valueProfileLabel.text = dataTestProfileArray[indexPath.row]
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
            let object = commentArray[indexPath.row] as CommentModel
            cell.initCell(object: object)
            return cell
        }
    }
    
    
    /* ========== COLLECTION VIEW DELEGATE, DATA SOURCE ============ */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        return item
    }
    
    /*============== COLLECTION VIEW FLOW LAYOUT ============ */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow - 8
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getServiceDetail() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = serviceObject?.service_id
        
        LoadingOverlay.shared.showOverlay(view: self.view)
        APIManager.sharedInstance.getDataToURL(url: SERVICE_GET_DETAIL, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
            self.getListComment(pageIndex: 0)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    
//                    let listItem = resultData["items"] as! [AnyObject]
//                    var tempArray = [ServiceModel]()
//                    for i in 0..<listItem.count {
//                        let item = listItem[i] as! [String:AnyObject]
//                        let newsObject = ServiceModel.init(dict: item)
//                        tempArray += [newsObject]
//                    }
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })

    }
    
    func getListComment(pageIndex:Int) -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = serviceObject?.service_id
        dictParam["page_index"] = String.init(format: "%d", pageIndex)
        
        LoadingOverlay.shared.showOverlay(view: self.view)
        APIManager.sharedInstance.getDataToURL(url: COMMENT_GET, parameters: dictParam, onCompletion: {(response) in
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
                    let listItem = resultData["items"] as! [AnyObject]
                    var tempArray = [CommentModel]()
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = CommentModel.init(dict: item)
                        tempArray += [newsObject]
                    }
                    self.commentArray += tempArray
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
