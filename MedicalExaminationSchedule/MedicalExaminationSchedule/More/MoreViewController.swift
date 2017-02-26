//
//  MoreViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/4/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import FBSDKCoreKit
import FBSDKLoginKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateCommentViewDelegate, FirstRegisterDoctorVCDelegate,UITextFieldDelegate,UITextViewDelegate {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var moreTableView: UITableView!
    
    @IBOutlet weak var backgroundPopupView: UIView!
    @IBOutlet weak var editMyProfileButton: UIButton!
    var iconArray = [String]()
    var titleArray = [String]()
    var iconArrayDoctor = [String]()
    var titleArrayDoctor = [String]()
    var isDoctor = false
    var userModel : UserModel?
    var appDelegate = AppDelegate()
    
    static let sharedInstance : MoreViewController = {
        let instance = MoreViewController()
        return instance
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(returnKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
 
        // Do any additional setup after loading the view.
        ProjectCommon.boundView(button: avatarImageView, cornerRadius: avatarImageView.frame.size.height/2, color: UIColor.white, borderWith: 0)
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        moreTableView.register(UINib.init(nibName: "NormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NormalTableViewCell")
        moreTableView.rowHeight = UITableViewAutomaticDimension;
        moreTableView.estimatedRowHeight = 70.0;
        moreTableView.tableFooterView = UIView.init(frame: CGRect.zero)
        
        iconArray += ["ic_imadoctor","ic_comment","ic_about"]
        titleArray += ["Tôi là bác sỹ","Đóng góp ý kiến","Hướng dẫn sử dụng"]
        iconArrayDoctor += ["ic_setup_calendar","ic_setup_service","ic_folder_image","ic_imadoctor","ic_comment","ic_about"]
        titleArrayDoctor += ["Thiết lập lịch hẹn","Thiết lập giới thiệu dịch vụ","Thư mục ảnh","Mời bác sỹ tham gia","Đóng góp ý kiến", "Hướng dẫn sử dụng"]
        self.createPopup()
        self.getProfile()
        
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(getProfile), name: NSNotification.Name(rawValue: UPDATE_PROFILE_SUCCESS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getAvatarUrl), name: NSNotification.Name(rawValue: UPDATE_AVATAR_SUCCESS), object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
        
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func returnKeyboard() {
        view.endEditing(true)
    }
    
    func createPopup() -> Void {
        let popupView = UINib(nibName: "CreateCommentView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! CreateCommentView
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 5.0
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.delegate = self
        popupView.commentTextView.delegate = self
        popupView.suggestionTitleTextField.delegate = self
        backgroundPopupView.addSubview(popupView)
        
        let views = ["popupView": popupView,
                     "backgroundPopUpView": backgroundPopupView]
        let width = view.frame.size.width - 30
        
        let dictMetric = ["widthPopup" : width]
        
        // 2
        var allConstraints = [NSLayoutConstraint]()
        
        // 3
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundPopUpView]-(<=1)-[popupView(270)]",
            options: [.alignAllCenterX],
            metrics: nil,
            views: views)
        allConstraints += verticalConstraints
        // 4
        let horizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[backgroundPopUpView]-(<=1)-[popupView(widthPopup)]",
            options: [.alignAllCenterY],
            metrics: dictMetric,
            views: views)
        allConstraints += horizontalConstraints
        
        backgroundPopupView.addConstraints(allConstraints)
        backgroundPopupView.isHidden = true
    }
    
    func getProfile() -> Void {
        
        var dictParam = [String : AnyObject]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as AnyObject?
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: USER_INFO, parameters: dictParam as! [String : String], onCompletion: { (response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil)
            {
                // error
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy thông tin thành viên,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    // dismiss
                })
                return
            }
            let value = response.result.value as! [String:AnyObject]
            
            if (value["status"] as! NSNumber) == 1 {
                // success
                let dictResult = value["result"] as! [String:AnyObject]
                self.userModel = UserModel.init(dict: dictResult)
                if (self.userModel?.user_display_name == ""){
                    self.usernameLabel.text = "No name"
                }else {
                    self.usernameLabel.text = self.userModel?.user_display_name
                }
                print((self.userModel?.user_type_id)!)
                self.isDoctor = (self.userModel?.user_type_id)!
                self.getUserServiceId()
                self.getAvatarUrl()
                self.moreTableView.reloadData()
            }
        })
    }
    
    func getUserServiceId() -> Void {
        var dictParam = [String : AnyObject]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as AnyObject?
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: SERVICE_USER, parameters: dictParam as! [String : String], onCompletion: { (response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil)
            {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xảy ra lỗi trong quá trình lấy thông tin thành viên,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                })
                return
            }
            let value = response.result.value as! [String:AnyObject]
            
            if (value["status"] as! NSNumber) == 1 {
                // success
                let dictResult = value["result"] as! [String:AnyObject]
                let listItem = dictResult["items"] as! [AnyObject]
                self.userModel?.list_sevice_id = listItem
                if listItem.count > 0 {
                    let itemObj = listItem[0] as! [String:AnyObject]
                    if let v = itemObj["id"] {
                        self.userModel?.service_id = "\(v)"
                    }
                }
            }
        })
    }
    
    func getAvatarUrl() -> Void {
    
        var dictParam = [String:String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["image_type"] = "profile"
        APIManager.sharedInstance.getDataToURL(url: IMAGE_USER, parameters: dictParam, onCompletion: {(response) in
            print(response)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message:"Không thể tải ảnh lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    let resultData = resultDictionary["result"] as! [String:AnyObject]
                    let listItem = resultData["items"] as! [AnyObject]
                    if listItem.count > 0 {
                        let item = listItem[0] as! [String:AnyObject]
                        self.userModel?.avatar_url = item["url"] as! String?
                        self.userModel?.avatar_id = item["id"] as! String?
                        self.avatarImageView.loadImage(url: item["url"] as! String)
                    }else {
                        self.avatarImageView.image = UIImage.init(named: "ic_avar_map")
                    }
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Không thể tải ảnh lúc này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    })
                }
            }
        })
    }

    
    @IBAction func tappedSignOutButton(_ sender: Any) {
        // Sign out
        UserDefaults.standard.removeObject(forKey: "token_id")
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedMyProfileButton(_ sender: Any) {
        if !isDoctor {
            self.performSegue(withIdentifier: "pushToUpdateUserProfile", sender: self)
        } else {
            self.performSegue(withIdentifier: "PushToUpdateProfileDoctor", sender: self)
        }
    }
    
    /* ============= TABLEVIEW DELEGATE, DATASOURCE ============== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (!isDoctor) {
            return iconArray.count
        } else {
            return iconArrayDoctor.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifierString = "NormalTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierString, for: indexPath) as! NormalTableViewCell
        if (!isDoctor) {
            cell.setupCell(icon: iconArray[indexPath.row], title: titleArray[indexPath.row])
        } else {
            cell.setupCell(icon: iconArrayDoctor[indexPath.row], title: titleArrayDoctor[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isDoctor {
            if indexPath.row == 0 {
                // tôi là bác sỹ
                self.performSegue(withIdentifier: "PushToFirstRegisterDoctor", sender: self)
            } else if indexPath.row == 1 {
                //Đóng góp ý kiến
                backgroundPopupView.isHidden = false
            } else {
                self.performSegue(withIdentifier: "guidApp", sender: nil)
                // hướng dẫn
            }
        }else {
            switch indexPath.row {
            case 0:
                // Thiết lập lịch hẹn
                self.performSegue(withIdentifier: "PushToSetupCalendar", sender: self)
                break
            case 1:
                // Thiết lập giới thiệu dịch vụ
                self.performSegue(withIdentifier: "PushToSetupIntroduce", sender: self)
                break
            case 2:
                // Thư mục ảnh
                self.performSegue(withIdentifier: "PushToListPhoto", sender: self)
                break
            case 3:
                // Mời bác sỹ tham gia
                self.performSegue(withIdentifier: "PushToInviteDoctor", sender: self)
                break
            case 4:
                //Đóng góp ý kiến
                backgroundPopupView.isHidden = false
                break
            default:
                // hướng dẫn
                self.performSegue(withIdentifier: "guidApp", sender: nil)
                break
            }
        }
        
     }
    
    /* =========== CREATE COMMENT VIEW DELEGATE =========== */
    func closePopup() {
        backgroundPopupView.isHidden = true
    }
    
    func sendComment(title: String, suggesstion: String) {
        if title.characters.count > 0 && suggesstion.characters.count > 0 {
            let parameter:[String:String] = ["token_id":(UserDefaults.standard.object(forKey: "token_id") as? String)!,"title":title,"content":suggesstion]
            LoadingOverlay.shared.showOverlay(view: view)
            APIManager.sharedInstance.postDataToURL(url: SUGGESTION, parameters: parameter, onCompletion: { response in
                if response.result.error == nil && response.result.isSuccess {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã gửi ý kiến thành công", buttonArray: ["Đóng"], onCompletion: {_ in
                        self.backgroundPopupView.isHidden = true
                        LoadingOverlay.shared.hideOverlayView()
                    })
                } else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Đóng góp ý kiến thất bại, vui lòng thử lại", buttonArray: ["Đóng"], onCompletion: {_ in
                        self.backgroundPopupView.isHidden = true
                        LoadingOverlay.shared.hideOverlayView()
                    })
                }
            })
        } else {
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Vui lòng nhập nội dung đóng góp ý kiến!", buttonArray: ["Đóng"], onCompletion: {_ in
            })
        }
        
    }

    /* =========== REGISTER SUCCESS ============== */
    func registerDoctorSuccess() {
        isDoctor = true
        userModel?.user_type_id = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pushToUpdateUserProfile" {
            let updateVC = segue.destination as! UpdateUserViewController
            updateVC.userProfile = self.userModel
            updateVC.imageAvatar = avatarImageView.image!
        }else if (segue.identifier == "PushToFirstRegisterDoctor") {
            let registerVC = segue.destination as! FirstRegisterDoctorViewController
            registerVC.delegate = self
            registerVC.userProfile = self.userModel
            registerVC.imageAvatar = avatarImageView.image!
        }else if (segue.identifier == "PushToUpdateProfileDoctor") {
            let updateVC = segue.destination as! UpdateProfileDoctorViewController
            updateVC.userProfile = self.userModel
            updateVC.imageAvatar = avatarImageView.image!
        }else if (segue.identifier == "PushToSetupIntroduce") {
            let vc  = segue.destination as! SetupIntroduceViewController
            vc.userProfile = self.userModel
        }else if (segue.identifier == "PushToSetupCalendar") {
            let vc = segue.destination as! SettingCalendarViewController
            vc.userProfile = self.userModel
        }else if (segue.identifier == "PushToListPhoto") {
            let vc = segue.destination as! ListPhotoViewController
            vc.userProfile = self.userModel

        }
    }


}
