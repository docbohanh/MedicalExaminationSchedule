//
//  DocumentViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Hai Dang Nguyen on 1/3/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var backButton: NSLayoutConstraint!
    @IBOutlet weak var webview: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webview.loadRequest(URLRequest.init(url: URL.init(string: "https://www.edx.org/course")!))
        self.navigationController?.navigationBar.isHidden = true
        // Do any additional setup after loading the view.
    }

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if navigationType == UIWebViewNavigationType.linkClicked {
            UIApplication.shared.openURL(URL.init(string: "https://www.edx.org/course")!)
            return false
        }
        return true
    }
    
    @IBAction func tappedBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
