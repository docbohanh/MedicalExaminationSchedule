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
//    @IBOutlet weak var doctorHistoryLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var sendCommentButton: UIButton!
    @IBOutlet weak var titleCommentTextField: UITextField!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
//    private weak var calendar: FSCalendar!
    let titleProfileArray = ["Họ tên","Địa chỉ","Giới tính","Chuyên ngành","Nơi làm việc"]
    var dataTestProfileArray = [String]()
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)

    var serviceObject : ServiceModel?
    var rate = 0
    var commentArray = [CommentModel]()
    var commentCounter = [Int]()
    var tabIndex = 0
    var introduceArray = [IntroduceModel]()
    var imagesArray = [ImageModel]()
    
    
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
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        self.tappedDoctorProfile(profileTabButton)
        self.getServiceDetail()
        self.getListPhoto()
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
        commentView.frame = CGRect.init(x: commentView.frame.origin.x, y: commentView.frame.origin.y, width: commentView.frame.width, height: sendCommentButton.frame.size.height + sendCommentButton.frame.origin.y + 10)
//        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.origin.y + doctorHistoryLabel.frame.size.height + doctorHistoryLabel.frame.origin.y)
    }
    
    @IBAction func tappedBack(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedCallDoctor(_ sender: UIButton) {
    }
    
    @IBAction func tappedBookCalendar(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "More", bundle: nil)
        let scheduleVC = storyboard.instantiateViewController(withIdentifier: "SettingCalendarViewController") as! SettingCalendarViewController
        scheduleVC.serviceObject = serviceObject
        scheduleVC.isBookFlow = true
        self.navigationController?.pushViewController(scheduleVC, animated: true)
    }
    
    @IBAction func tappedSeeDoctorLocation(_ sender: Any) {
    }
    
    @IBAction func tappedDoctorInformation(_ sender: UIButton) {
        tabIndex = 1
        tabLineView.center = CGPoint.init(x: informationTabButton.center.x, y: tabLineView.center.y)
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: backgroundInformationView.frame.size.height + informationTableView.frame.size.height)
        backgroundScrollView.scrollRectToVisible(CGRect.init(x: informationTabButton.frame.origin.x, y: backgroundInformationView.frame.size.height - informationTabButton.frame.size.height, width: backgroundScrollView.frame.size.width, height: backgroundScrollView.frame.size.height), animated: true)
        informationTableView.isHidden = false
        commentView.isHidden = true
        informationTableView.reloadData()
        self.reloadSelectedButton()
    }
    
    @IBAction func tappedDoctorProfile(_ sender: Any) {
        tabIndex = 0
        tabLineView.center = CGPoint.init(x: profileTabButton.center.x, y: tabLineView.center.y)
        commentView.isHidden = true
        informationTableView.isHidden = false
        imageCollectionView.isHidden = true
        informationTableView.reloadData()
        self.reloadSelectedButton()
    }
    
    @IBAction func tappedGetImageFromDevice(_ sender: UIButton) {
        tabIndex = 2
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: imageCollectionView.frame.origin.y + imageCollectionView.frame.height)
        tabLineView.center = CGPoint.init(x: imageTabButton.center.x, y: tabLineView.center.y)
        informationTableView.isHidden = true
        commentView.isHidden = true
        imageCollectionView.isHidden = false
        imageCollectionView.reloadData()
        self.reloadSelectedButton()
    }
    @IBAction func tappedComment(_ sender: UIButton) {
        tabIndex = 3
        backgroundScrollView.contentSize = CGSize.init(width: backgroundScrollView.frame.size.width, height: commentView.frame.origin.y + commentView.frame.height)
        tabLineView.center = CGPoint.init(x: commentTabButton.center.x, y: tabLineView.center.y)
        informationTableView.isHidden = true
        commentView.isHidden = false
        imageCollectionView.isHidden = true
        self.reloadSelectedButton()
    }
    
    @IBAction func tappedSendComment(_ sender: UIButton) {
        view.endEditing(true)
        if titleCommentTextField.text == "" {
            ProjectCommon.initAlertView(viewController: self, title: "Error", message: "Chưa nhập tiêu đề", buttonArray: ["OK"], onCompletion: { (index) in
            })
            return
        }
        // Send comment
        self.sendComment()
    }
    
    func reloadSelectedButton() -> Void {
        
        informationTabButton.isSelected = false
        profileTabButton.isSelected = false
        imageTabButton.isSelected = false
        commentTabButton.isSelected = false
        switch tabIndex {
        case 0:
            profileTabButton.isSelected = true
            break
        case 1:
            informationTabButton.isSelected = true
            break
        case 2:
            imageTabButton.isSelected = true
            break
        default:
            commentTabButton.isSelected = true
            break
        }
    }
    
    @IBAction func tappedStarButton(_ sender: Any) {
        let button = sender as! UIButton
        let tag = button.tag
        rate = tag - 10 + 1
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

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tabIndex == 0 {
            return 1
        }else {
             return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tabIndex == 0 {
            return introduceArray.count
        } else {
            if section == 0 {
                return 5
            }
            return commentArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tabIndex == 0 {
            return 0
        }
        if section == 1 {
            return 220
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("RateHeaderView", owner: self, options: nil)?.first as! RateHeaderView
        headerView.setupViewWithArray(array: commentCounter)
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tabIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            let object = introduceArray[indexPath.row] as IntroduceModel
            cell.initCell(object: object)
            return cell
        }else {
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
    }
    
    
    /* ========== COLLECTION VIEW DELEGATE, DATA SOURCE ============ */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let object = imagesArray[indexPath.row]
        item.photoImageView.loadImage(url: object.url!)
        item.checkButton.isHidden = true
        return item
    }
    
    /*============== COLLECTION VIEW FLOW LAYOUT ============ */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
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
    
    /* ---------------- API -------------- */
    func getServiceDetail() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = serviceObject?.service_id
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: SERVICE_DETAIL, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            self.getListComment(pageIndex: 0)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["contents"] as! [AnyObject]
                    var tempArray = [IntroduceModel]()
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = IntroduceModel.init(dict: item)
                        tempArray.append(newsObject)
                    }
                    self.introduceArray += tempArray
                    self.informationTableView.reloadData()
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
        
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: COMMENT, parameters: dictParam, onCompletion: {(response) in
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
                    var tempArray = [CommentModel]()
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = CommentModel.init(dict: item)
                        tempArray += [newsObject]
                    }
                    if pageIndex == 0 {
                        if (self.commentArray.count > 0)
                        {
                             self.commentArray.removeAll()
                        }
                    }
                    self.commentArray += tempArray
                    self.counterStar(array: self.commentArray)
                    self.informationTableView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                    })
                }
            }
        })

    }
    
    func sendComment() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["service_id"] = serviceObject?.service_id
        dictParam["comment_content"] = commentTextView.text
        dictParam["comment_title"] = titleCommentTextField.text
        dictParam["rate"] = String.init(format: "%d", rate)
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.postDataToURL(url: COMMENT, parameters: dictParam, onCompletion: { (response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    ProjectCommon.initAlertView(viewController: self, title: "Success", message: "Send comment success", buttonArray: ["OK"], onCompletion: { (index) in
                        self.getListComment(pageIndex: 0)
                    })
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func getListPhoto() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["service_id"] = serviceObject?.service_id
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: IMAGE_SERVICE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // reload data
                    if self.imagesArray.count > 0 {
                        self.imagesArray.removeAll()
                    }
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    for i in 0..<listItem.count {
                        let item = listItem[i] as! [String:AnyObject]
                        let newsObject = ImageModel.init(dict: item)
                        self.imagesArray += [newsObject]
                    }
                    self.imageCollectionView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    
    func counterStar(array:[CommentModel]) -> Void {
        let totalRate = array.count
        if array.count == 0 {
            return
        }
        var rate1 = 0
        var rate2 = 0
        var rate3 = 0
        var rate4 = 0
        var rate5 = 0
        for i in 0 ..< array.count {
            let model = array[i]
            switch model.rate! as Int {
            case 1 :
                rate1 += 1
                break
            case 2 :
                rate2 += 1
                break
            case 3 :
                rate3 += 1
                break
            case 4 :
                rate4 += 1
                break
            case 5 :
                rate5 += 1
                break
            default:
                break
            }
        }
        // avg
        let avg = (rate1*1 + rate2*2 + rate3*3 + rate4*4 + rate5*5)/totalRate
        rateImageView.image = UIImage.init(named: String.init(format: "ic_star_%d", avg))
        if commentCounter.count > 0{
            commentCounter.removeAll()
        }
        commentCounter += [rate1,rate2,rate3,rate4,rate5,totalRate]
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
