//
//  UpdateUserViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class UpdateUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ProfileTableViewCellDelegate, BottomViewDelegate,ChangeAvatarViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundPopUpView: UIView!
    
    var titleArray = [String]()
    var imageAvatar = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageAvatar = UIImage.init(named: "ic_avar_map")!
        titleArray += ["Họ Tên","Mật khẩu","Địa chỉ","Ngày sinh","Điện thoại","Email","Giới tính"]

        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 200.0;
        
        let bottomButtonView = UINib(nibName: "BottomView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! BottomView
        bottomButtonView.delegate = self
        bottomButtonView.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 170)
        tableView.tableFooterView = bottomButtonView
        // register cell
        tableView.register(UINib.init(nibName: "ProfileTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ProfileTableViewCell")
        tableView.register(UINib.init(nibName: "SelectGenderTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SelectGenderTableViewCell")
        tableView.register(UINib.init(nibName: "TextFieldNormalTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TextFieldNormalTableViewCell")
        self.createPopup()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createPopup() -> Void {
        let popupView = UINib(nibName: "ChangeAvatarView", bundle: Bundle.main).instantiate(withOwner: nil, options: nil)[0] as! ChangeAvatarView
        popupView.clipsToBounds = true
        popupView.layer.cornerRadius = 5.0
        popupView.translatesAutoresizingMaskIntoConstraints = false
        popupView.delegate = self
        backgroundPopUpView.addSubview(popupView)
        
        let views = ["popupView": popupView,
                     "backgroundPopUpView": backgroundPopUpView]
        let width = view.frame.size.width - 30
        
        let dictMetric = ["widthPopup" : width]

        // 2
        var allConstraints = [NSLayoutConstraint]()
        
        // 3
        let verticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:[backgroundPopUpView]-(<=1)-[popupView(220)]",
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
        
        backgroundPopUpView.addConstraints(allConstraints)
        backgroundPopUpView.isHidden = true
    }
    
    /* ========  TABLE VIEW =========== */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var strIdentifier = ""
        switch indexPath.row {
        case 0:
            strIdentifier = "ProfileTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
            cell.avatarImageView.image = imageAvatar

            cell.delegate = self
            return cell
        case titleArray.count:
            strIdentifier = "SelectGenderTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectGenderTableViewCell", for: indexPath) as! SelectGenderTableViewCell
            cell.titleLabel.text = titleArray[indexPath.row-1]
            return cell
        default:
            strIdentifier = "TextFieldNormalTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldNormalTableViewCell", for: indexPath) as! TextFieldNormalTableViewCell
            cell.titleLabel.text = titleArray[indexPath.row-1]
            cell.cellTextField.delegate = self
            return cell
        }
    }
    
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /* =========== TEXT FIELD ========*/
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /* ========== PROFILE CELL DELEGATE =========== */
    func changeAvatar() {
        backgroundPopUpView.isHidden = false
    }
    
    /* ============= BOTTOM VIEW DELEGATE ============= */
    func updateProfile() {
        
    }

    func cancel() {
        
    }
    /* ============= CHANGE AVATAR VIEW DELEGATE ============= */
    
    func closePopup() {
        backgroundPopUpView.isHidden = true
    }
    
    func deleteAvatar() {
        backgroundPopUpView.isHidden = true
        imageAvatar = UIImage.init(named: "ic_avar_map")!
        tableView.reloadData()
    }
    
    func takePhoto() {
        backgroundPopUpView.isHidden = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
    func chooseFromLibrary() {
        backgroundPopUpView.isHidden = true
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    /* ============= IMAGE PICKER CONTROLLER DELEGATE ========= */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageAvatar = pickedImage
            tableView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
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
