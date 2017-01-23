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

//extension ViewController: UIWebViewDelegate {
//    func webViewDidFinishLoad(webView: UIWebView) {
//        print(webView.request?.URL)
//        webviewHeightConstraint.constant = webView.scrollView.contentSize.height
//        if (!observing) {
//            startObservingHeight()
//        }
//    }
//}
var MyObservationContext = 0

class DetailNewViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var imageViewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var webview: UIWebView!
    
    var delegate : DetailNewControllerDelegate?
    @IBOutlet weak var webviewHeightConstraint: NSLayoutConstraint!
    var observing = false

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
        // fake test
        if newsObject?.news_url != "" {
            newsImageView.isHidden = false
//            imageViewHeightConstant.constant = 150
            
            newsImageView.loadImage(url: (newsObject?.news_url)!)

            
        }else {
            newsImageView.isHidden = true
            imageViewHeightConstant.constant = 0
        }
        webview.scrollView.isScrollEnabled = false
        webview.delegate = self
    }
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: webview.frame.size.height + webview.frame.origin.y)
        scrollView.layoutIfNeeded()
        if newsImageView.image != nil {
            let rate = (newsImageView.image?.size.height)!/(newsImageView.image?.size.width)!
            imageViewHeightConstant.constant = self.view.frame.size.width * rate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        webView.frame.size.height = 2
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        scrollView.contentSize = CGSize.init(width: scrollView.frame.size.width, height: webview.frame.size.height + webview.frame.origin.y)
        scrollView.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    deinit {
//        stopObservingHeight()
//    }
//    
//    func startObservingHeight() {
//        let options = NSKeyValueObservingOptions([.new])
//        webview.scrollView.addObserver(self, forKeyPath: "contentSize", options: options, context: &MyObservationContext)
//        observing = true;
//    }
//    
//    func stopObservingHeight() {
//        webview.scrollView.removeObserver(self, forKeyPath: "contentSize", context: &MyObservationContext)
//        observing = false
//    }
//    
//    func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutableRawPointer) {
//        guard let keyPath = keyPath else {
//            super.observeValueForKeyPath(nil, ofObject: object, change: change as! [NSKeyValueChangeKey : Any]?, context: context)
//            return
//        }
//        switch (keyPath, context) {
//        case("contentSize", &MyObservationContext):
//            webviewHeightConstraint.constant = webview.scrollView.contentSize.height
//        default:
//            super.observeValueForKeyPath(keyPath, ofObject: object, change: change as! [NSKeyValueChangeKey : Any]?, context: context)
//        }
//    }
    
    func getLikeContent() -> Void {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObject?.news_id
        Lib.showLoadingViewOn2(view, withAlert: "Loading ...")
        APIManager.sharedInstance.getDataToURL(url: NEWS_CONTENT, parameters: dictParam, onCompletion: {(response) in
            print(response)
            Lib.removeLoadingView(on: self.view)
            if (response.result.error != nil) {
                ProjectCommon.initAlertView(viewController: self, title: "Đả xảy ra lỗi", message: (response.result.error?.localizedDescription)!, buttonArray: ["Đóng"], onCompletion: { (index) in
                    
                })
            }else {
                let resultDictionary = response.result.value as! [String:AnyObject]
                if (resultDictionary["status"] as! NSNumber) == 1 {
                    // update like button
                    let resultData = resultDictionary["result"]
                    self.likeButton.isSelected = resultData?["liked"] as! Bool
                    let likeContent = resultData?["content"] as! String
                    self.webview.loadHTMLString(likeContent, baseURL: nil)
//                    self.content.text = likeContent.fromBase64()?.html2String
                }else {
                    ProjectCommon.initAlertView(viewController: self, title: "", message:"Không thể xác định trạng thái Like ở thời điểm này,vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    })
                }
            }
        })

    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.delegate?.updateNews(newObject:newsObject!)
        _ = navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedShareButton(_ sender: Any) {
    }
    
    @IBAction func tappedLikeButton(_ sender: Any) {
        var dictParam = [String : String]()
        dictParam["token_id"] = UserDefaults.standard.object(forKey: "token_id") as! String?
        dictParam["news_id"] = newsObject?.news_id
        Lib.showLoadingViewOn2(view, withAlert: "Đang tải ...")
        APIManager.sharedInstance.postDataToURL(url: NEWS_LIKE, parameters: dictParam, onCompletion: {(response) in
            Lib.removeLoadingView(on: self.view)
            print(response)
            if response.result.error != nil {
                ProjectCommon.initAlertView(viewController: self, title: "", message:"Không thể thích bài viết lúc này, vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                    
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
                    ProjectCommon.initAlertView(viewController: self, title: "", message:"Không thể thích bài viết lúc này, vui lòng quay lại sau", buttonArray: ["Đóng"], onCompletion: { (index) in
                        
                    })
                }
            }
        })

    }

}
