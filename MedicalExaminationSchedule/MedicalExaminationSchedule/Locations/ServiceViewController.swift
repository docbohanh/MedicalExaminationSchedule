//
//  ServiceViewController.swift
//  MedicalExaminationSchedule
//
//  Created by Nguyen Hai Dang on 1/16/17.
//  Copyright © 2017 Nguyen Hai Dang. All rights reserved.
//

import UIKit

class ServiceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    let modelNameArray:[String] = ["Bệnh viện","Nhà thuốc","Phòng khám","Bác sĩ","Comming soon"]
    let modelImageArray:[String] = ["ic_hospital","ic_pharmacy","ic_clinic","ic_doctor", "ic_comingsoon"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize.init(width: 5 * scrollView.frame.width, height: scrollView.frame.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initScrollView()
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize.init(width: 5 * scrollView.frame.width, height: scrollView.frame.height)
    }
    
    func initScrollView() {
        scrollView.contentSize = CGSize.init(width: 5 * scrollView.frame.width, height: scrollView.frame.height)
        scrollView.isPagingEnabled = true
        scrollView.isScrollEnabled = true
        for index in 0...4 {
            let logoImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(index) * scrollView.frame.width, y:0, width: scrollView.frame.width, height: scrollView.frame.height))
            let image:String = modelImageArray[index]
            logoImageView.image = UIImage.init(named: image)
            scrollView.addSubview(logoImageView)
            
            let iconImageView = UIImageView.init(frame: CGRect.init(x: (logoImageView.frame.width - 125)/2, y:40, width: 125, height: 32))
            iconImageView.image = UIImage.init(named: "ic_logo_nav")
            logoImageView.addSubview(iconImageView)
            
            let backgroundButton = UIButton.init(type: UIButtonType.custom)
            backgroundButton.frame = CGRect.init(x: CGFloat(index) * scrollView.frame.width, y: (logoImageView.frame.height - 160)/2, width: scrollView.frame.width, height: 160)
            backgroundButton.backgroundColor = UIColor.clear
            backgroundButton.tag = 480 + index
            backgroundButton.addTarget(self, action: #selector(gotoServices(sender:)), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(backgroundButton)
            
            let modelNameLabel = UILabel.init(frame: CGRect.init(x: 0, y: logoImageView.frame.height - 150, width: scrollView.frame.width, height: 30))
            modelNameLabel.textColor = UIColor.white
            modelNameLabel.font = UIFont.systemFont(ofSize: 16)
            modelNameLabel.text = modelNameArray[index]
            modelNameLabel.textAlignment = .center
            logoImageView.addSubview(modelNameLabel)
            
            for i in 0...4 {
                let circleImageView = UIImageView.init(frame: CGRect.init(x:Int(logoImageView.frame.width/2 - CGFloat(35) + CGFloat(i) * 14), y: Int(logoImageView.frame.height - 90), width: 8, height: 8))
                if i > index {
                circleImageView.frame = CGRect.init(x:Int(logoImageView.frame.width/2 - CGFloat(35) + CGFloat(i) * 14), y: Int(logoImageView.frame.height - 90), width: 8, height: 8)
                    circleImageView.image = UIImage.init(named: "ic_ellipse_small")
                } else {
                circleImageView.frame = CGRect.init(x:Int(logoImageView.frame.width/2 - CGFloat(35) + CGFloat(i) * 14), y: Int(logoImageView.frame.height - 90), width: 10, height:10)
                    circleImageView.image = UIImage.init(named: "ic_ellipse")
                }
                logoImageView.addSubview(circleImageView)
            }
        }
    }
    
    func gotoServices(sender:UIButton) {
        let tag = sender.tag - 480
        let storyboard = UIStoryboard.init(name: "Locations", bundle: nil)
        switch tag {
        case 0:
            let hospitalViewController = storyboard.instantiateViewController(withIdentifier: "HospitalListViewController") as! HospitalListViewController
            self.navigationController?.pushViewController(hospitalViewController, animated: true)
            break
        case 1:
            let drugViewController = storyboard.instantiateViewController(withIdentifier: "DrugStoreViewController") as! DrugStoreViewController
            self.navigationController?.pushViewController(drugViewController, animated: true)
            break
        case 2:
            let clinicViewController = storyboard.instantiateViewController(withIdentifier: "ClinicViewController") as! ClinicViewController
            self.navigationController?.pushViewController(clinicViewController, animated: true)
            break
        case 3:
            let doctorViewController = storyboard.instantiateViewController(withIdentifier: "DoctorListViewController") as! DoctorListViewController
            self.navigationController?.pushViewController(doctorViewController, animated: true)
            break
        case 4:
            //Comming soon
            break
        default:
            break
        }
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
