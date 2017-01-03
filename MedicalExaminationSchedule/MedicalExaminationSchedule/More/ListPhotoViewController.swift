//
//  ListPhotoViewController.swift
//  MedicalExaminationSchedule
//
//  Created by ThuyPH on 12/7/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ListPhotoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate, PhotoCellDelegate, NewImageDelegate {
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 3.0, right: 2.0)
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var addButton: UIButton!
    var imagesArray = [ImageModel]()
    var isShowDeleteImage = false
    var selectedImageArray = [ImageModel]()
    var userProfile : UserModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if userProfile?.avatar_url != nil {
             avatarImageView.loadImage(url: (userProfile?.avatar_url)!)
        }else {
            avatarImageView.image = UIImage.init(named: "ic_avar_map")
        }
       
        doctorNameLabel.text = userProfile?.user_display_name
        photoCollectionView.register(UINib.init(nibName: "PhotoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        self.getListPhoto()
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector (handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.photoCollectionView.addGestureRecognizer(lpgr)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.began {
            for item in imagesArray {
                item.isSelected = false
            }
            isShowDeleteImage = true
            self.photoCollectionView.reloadData()
            addButton.setImage(UIImage.init(named: "ic_delete_image"), for: UIControlState.normal)
//            return
        }
        
//        let p = gestureReconizer.locationInView(self.collectionView)
//        let indexPath = self.collectionView.indexPathForItemAtPoint(p)
//        
//        if let index = indexPath {
//            var cell = self.collectionView.cellForItemAtIndexPath(index)
//            // do stuff with your cell, for example print the indexPath
//            println(index.row)
//        } else {
//            println("Could not find index path")
//        }
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedAddButton(_ sender: Any) {
        if isShowDeleteImage {
            // delete Image
            if selectedImageArray.count > 0 {
                self.deleteImageObject(object: selectedImageArray[0])
            } else {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Bạn chưa chọn ảnh nào để xoá", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }
        }else {
            let storyboard = UIStoryboard.init(name: "More", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewImageViewController") as! NewImageViewController
            vc.delegate = self
            vc.userProfile = self.userProfile
            navigationController?.pushViewController(vc, animated: true)
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
        if isShowDeleteImage {
            item.checkButton.isHidden = false
            item.checkButton.isSelected = object.isSelected
        }else {
            item.checkButton.isHidden = true
        }
        item.delegate = self
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isShowDeleteImage {
            isShowDeleteImage = false
            addButton.setImage(UIImage.init(named: "ic_add"), for: UIControlState.normal)
            photoCollectionView.reloadData()
        }
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
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    /* ------------- API ---------------*/
    func getListPhoto() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
//        dictParam["image_type"] = "image"
        dictParam["service_id"] = userProfile?.service_id
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: IMAGE_SERVICE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Tải ảnh thất bại,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
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
                    self.photoCollectionView.reloadData()
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message: "Tải ảnh thất bại,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })
    }
    func deleteImageObject(object:ImageModel) -> Void {
        var dictParam = [String:String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
        dictParam["image_id"] = object.id
        dictParam["service_id"] = userProfile?.service_id
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.deleteDataToURL(url: IMAGE_SERVICE, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            self.selectedImageArray.removeFirst()
            if self.selectedImageArray.count > 0 {
                self.deleteImageObject(object: self.selectedImageArray[0])
            }else {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Đã xoá thành công", buttonArray: ["Đóng"], onCompletion: { (index) in
                    self.isShowDeleteImage = false
                    self.addButton.setImage(UIImage.init(named: "ic_add"), for: UIControlState.normal)
                    self.getListPhoto()
                })
                if response.result.error != nil {
                    //                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["Đóng"], onCompletion: { (index) in
                    //
                    //                })
                } else {
                    let resultDictionary = response.result.value as! [String:AnyObject]
                    if (resultDictionary["status"] as! NSNumber) == 1 {
                    }else {
                        //                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["Đóng"], onCompletion: { (index) in
                        //
                        //                    })
                    }
                }
            }
        })
    }
    
    func selectedImage(cell:PhotoCollectionViewCell) {
        let indexPath = photoCollectionView.indexPath(for: cell)
        if cell.checkButton.isSelected{
            selectedImageArray.append(imagesArray[(indexPath?.row)!])
        }else {
            let currentItem = imagesArray[(indexPath?.row)!]
            for i in 0..<selectedImageArray.count {
                let item = selectedImageArray[i]
                if currentItem.id == item.id {
                    selectedImageArray.remove(at: i)
                }
            }
        }
    }
    
    func updateListImage() {
        self.getListPhoto()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
 

}
