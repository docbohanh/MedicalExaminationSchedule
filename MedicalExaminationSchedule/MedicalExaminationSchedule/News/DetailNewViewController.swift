//
//  DetailNewViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/6/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

protocol DetailNewControllerDelegate {
    func updateNews(newObject:NewsModel) -> Void
}

class DetailNewViewController: UIViewController {
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    var delegate : DetailNewControllerDelegate?
    

    var newsObject : NewsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleViewLabel.text = newsObject?.news_title
        titleLabel.text = newsObject?.news_title
        timeLabel.text = newsObject?.last_updated
        authorNameLabel.text = newsObject?.news_author
        descriptionLabel.text = newsObject?.news_desciption
        likeCountLabel.text = String.init(format: "%d", (newsObject?.like_count)!)
        self.getLikeContent()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getLikeContent() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObject?.news_id
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.getDataToURL(url: NEWS_GET_CONTENT, parameters: dictParam, onCompletion: {(response) in
            print(response)
            LoadingOverlay.shared.hideOverlayView()
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message: (response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // update like button
                    let resultData = resultDictionary["result"]
                    self.likeButton.isSelected = resultData?["liked"] as! Bool
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "Error", message: resultDictionary["message"] as! String, buttonArray: ["OK"], onCompletion: { (index) in
                        
                    })
                }
            }
        })

    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.delegate?.updateNews(newObject:newsObject!)
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedShareButton(_ sender: Any) {
    }
    
    @IBAction func tappedLikeButton(_ sender: Any) {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObject?.news_id
        LoadingOverlay.shared.showOverlay(view: self.navigationController?.view)
        APIManager.sharedInstance.postDataToURL(url: NEWS_POST_LIKE, parameters: dictParam, onCompletion: {(response) in
            LoadingOverlay.shared.hideOverlayView()
            print(response)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "Error", message:(response.result.error?.localizedDescription)!, buttonArray: ["OK"], onCompletion: { (index) in
                    
                })
            } else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    self.likeButton.isSelected = !self.likeButton.isSelected
                    var numberLike = 0
                    if self.likeButton.isSelected {
                        numberLike = (self.newsObject?.like_count)! + 1
                    }else {
                         numberLike = (self.newsObject?.like_count)! - 1
                    }
                    self.newsObject?.like_count = numberLike
                    self.likeCountLabel.text = String(format: "%d", (self.newsObject?.like_count)!)
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
