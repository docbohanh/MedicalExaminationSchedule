//
//  MoreViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/4/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateCommentViewDelegate {

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
    var isDoctor = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        moreTableView.register(UINib.init(nibName: "NormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NormalTableViewCell")
        moreTableView.rowHeight = UITableViewAutomaticDimension;
        moreTableView.estimatedRowHeight = 70.0;
        moreTableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        if iconArray.count > 0 {
            iconArray.removeAll()
        }
        if titleArray.count > 0 {
            titleArray.removeAll()
        }
        if isDoctor {
            iconArray += ["ic_setup_calendar","ic_setup_service","ic_folder_image","ic_imadoctor","ic_comment"]
            titleArray += ["Thiết lập lịch hẹn","Thiết lập giới thiệu dịch vụ","Thư mục ảnh","Mời bác sỹ tham gia","Đóng góp ý kiến"]
        }else {
            iconArray += ["ic_imadoctor","ic_comment"]
            titleArray += ["Tôi là bác sỹ","Đóng góp ý kiến"]
        }
        moreTableView.reloadData()
        self.createPopup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func createPopup() -> Void {
        let popupView = UINib(nibName: "CreateCommentView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! CreateCommentView
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 5.0
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.delegate = self
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
    
    @IBAction func tappedSignOutButton(_ sender: Any) {
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
        return iconArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifierString = "NormalTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifierString, for: indexPath) as! NormalTableViewCell
        cell.setupCell(icon: iconArray[indexPath.row], title: titleArray[indexPath.row])
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !isDoctor {
            if indexPath.row == 0 {
                // tôi là bác sỹ
                self.performSegue(withIdentifier: "PushToFirstRegisterDoctor", sender: self)
            } else if indexPath.row == 1 {
                // ý kiến
            }
        }else {
            switch indexPath.row {
            case 0:
                // Thiết lập lịch hẹn
                break
            case 1:
                // Thiết lập giới thiệu dịch vụ
                break
            case 2:
                // Thư mục ảnh
                self.performSegue(withIdentifier: "PushToListPhoto", sender: self)
                break
            case 3:
                // Mời bác sỹ tham gia
                break
            case 4:
                //Đóng góp ý kiến
                backgroundPopupView.isHidden = false
                break
            default:
                break
            }
        }
        
     }
    
    /* =========== CREATE COMMENT VIEW DELEGATE =========== */
    func closePopup() {
        backgroundPopupView.isHidden = true
    }
    
    func sendComment() {
        backgroundPopupView.isHidden = true
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "pushToUpdateUserProfile" {
//            let updateVC = segue.destination as! UpdateUserViewController
//            updateVC.isDoctor = isDoctor
            
        }
    }


}
