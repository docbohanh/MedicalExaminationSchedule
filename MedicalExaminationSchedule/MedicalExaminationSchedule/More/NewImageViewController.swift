//
//  NewImageViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 1/1/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit
import Photos

protocol NewImageDelegate {
    func updateListImage() -> Void
}

private extension UICollectionView {
    func indexPathsForElements(in rect: CGRect) -> [IndexPath] {
        let allLayoutAttributes = collectionViewLayout.layoutAttributesForElements(in: rect)!
        return allLayoutAttributes.map { $0.indexPath }
    }
}

class NewImageViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, PhotoCellDelegate {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var doctorNameLabel: UILabel!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    
    var fetchResult: PHFetchResult<PHAsset>!
    var assetCollection: PHAssetCollection!
    
    fileprivate let imageManager = PHCachingImageManager()
    fileprivate var thumbnailSize: CGSize!
    fileprivate var previousPreheatRect = CGRect.zero
    
    var photoArray = [AnyObject]()
    var selectedImageArray = [UIImage]()
    var selectedTag = [Int]()
    var userProfile : UserModel?
    var delegate : NewImageDelegate?
    
    
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
        resetCachedAssets()
        
        if fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        thumbnailSize = CGSize(width: 100, height: 100)
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "Screen NewImage ~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedSendButton(_ sender: Any) {
        if selectedImageArray.count > 0 {
            self.updateAvatarUser(imagePost: selectedImageArray[0])
        }else{
            ProjectCommon.initAlertView(viewController: self, title: "", message: "Bạn chưa chọn ảnh để upload", buttonArray: ["Đóng"], onCompletion: { (index) in
                
            })
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if #available(iOS 9.1, *) {
            guard let destination = segue.destination as? AssetViewController
                else { fatalError("unexpected view controller for segue") }
            let indexPath = photoCollectionView!.indexPath(for: sender as! UICollectionViewCell)!
            destination.asset = fetchResult.object(at: indexPath.item)
            destination.assetCollection = assetCollection
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    
    /* ========== COLLECTION VIEW DELEGATE, DATA SOURCE ============ */
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.delegate = self
        cell.tag = indexPath.row + 1000
        
        let asset = fetchResult.object(at: indexPath.item)
        // Request an image for the asset from the PHCachingImageManager.
        //        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager.requestImage(for: asset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            cell.photoImageView.image = image
        })
        
        return cell
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCachedAssets()
    }
    
    // MARK: Asset Caching
    
    fileprivate func resetCachedAssets() {
        imageManager.stopCachingImagesForAllAssets()
        previousPreheatRect = .zero
    }
    
    fileprivate func updateCachedAssets() {
        // Update only if the view is visible.
        guard isViewLoaded && view.window != nil else { return }
        
        // The preheat window is twice the height of the visible rect.
        let preheatRect = view!.bounds.insetBy(dx: 0, dy: -0.5 * view!.bounds.height)
        
        // Update only if the visible area is significantly different from the last preheated area.
        let delta = abs(preheatRect.midY - previousPreheatRect.midY)
        guard delta > view.bounds.height / 3 else { return }
        
        // Compute the assets to start caching and to stop caching.
        let (addedRects, removedRects) = differencesBetweenRects(previousPreheatRect, preheatRect)
        let addedAssets = addedRects
            .flatMap { rect in photoCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        let removedAssets = removedRects
            .flatMap { rect in photoCollectionView!.indexPathsForElements(in: rect) }
            .map { indexPath in fetchResult.object(at: indexPath.item) }
        
        // Update the assets the PHCachingImageManager is caching.
        imageManager.startCachingImages(for: addedAssets,
                                        targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        imageManager.stopCachingImages(for: removedAssets,
                                       targetSize: thumbnailSize, contentMode: .aspectFill, options: nil)
        
        // Store the preheat rect to compare against in the future.
        previousPreheatRect = preheatRect
    }
    
    fileprivate func differencesBetweenRects(_ old: CGRect, _ new: CGRect) -> (added: [CGRect], removed: [CGRect]) {
        if old.intersects(new) {
            var added = [CGRect]()
            if new.maxY > old.maxY {
                added += [CGRect(x: new.origin.x, y: old.maxY,
                                 width: new.width, height: new.maxY - old.maxY)]
            }
            if old.minY > new.minY {
                added += [CGRect(x: new.origin.x, y: new.minY,
                                 width: new.width, height: old.minY - new.minY)]
            }
            var removed = [CGRect]()
            if new.maxY < old.maxY {
                removed += [CGRect(x: new.origin.x, y: new.maxY,
                                   width: new.width, height: old.maxY - new.maxY)]
            }
            if old.minY < new.minY {
                removed += [CGRect(x: new.origin.x, y: old.minY,
                                   width: new.width, height: new.minY - old.minY)]
            }
            return (added, removed)
        } else {
            return ([new], [old])
        }
    }
    
    func selectedImage(cell:PhotoCollectionViewCell) {
        if cell.checkButton.isSelected{
            selectedImageArray.append(cell.photoImageView.image!)
            selectedTag.append(cell.tag)
        }else {
            for i in 0..<selectedTag.count {
                let item = selectedTag[i]
                if item == cell.tag {
                    selectedTag.remove(at: i)
                    selectedImageArray.remove(at: i)
                    break
                }
            }
        }
    }
    
    /* ------------- API --------------- */
    func updateAvatarUser(imagePost:UIImage) -> Void {
        var dictParam = [String:String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as? String
//        dictParam["image_type"] = "image"
        dictParam["image_title"] = ""
        dictParam["image_desc"] = ""
        dictParam["service_id"] = userProfile?.service_id
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.uploadImage(url: IMAGE_SERVICE, image: imagePost, param: dictParam, completion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            self.selectedImageArray.removeFirst()
            if self.selectedImageArray.count > 0 {
                self.updateAvatarUser(imagePost: self.selectedImageArray[0])
            }else {
                ProjectCommon.initAlertView(viewController: self, title: "", message: "Thêm ảnh thành công", buttonArray: ["Đóng"], onCompletion: { (index) in
                    self.delegate?.updateListImage()
                    _ = self.navigationController?.popViewController(animated: true)
                })
                if response.result.error != nil {
                    //                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    //
                    //                })
                } else {
                    let resultDictionary = response.result.value as! [String:AnyObject]
                    if (resultDictionary["status"] as! NSNumber) == 1 {
                    }else {
                        //                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        //                        
                        //                    })
                    }
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
