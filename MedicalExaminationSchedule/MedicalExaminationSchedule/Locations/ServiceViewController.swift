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
    let modelNameArray:[String] = ["Bệnh viện","Nhà thuốc","Phòng khám","Bác sĩ"]
    let modelImageArray:[String] = ["ic_hospital","ic_pharmacy","ic_clinic","ic_doctor"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.contentSize = CGSize.init(width: 4 * scrollView.frame.width, height: scrollView.frame.height)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.initScrollView()

    }
    func initScrollView() {
        for index in 0...3 {
            let backgroundButton = UIButton.init(type: UIButtonType.custom)
            backgroundButton.frame = CGRect.init(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            let image:String = modelImageArray[index]
            backgroundButton.setBackgroundImage(UIImage.init(named: image), for: UIControlState.normal)
            backgroundButton.tag = 480 + index
            backgroundButton.addTarget(self, action: #selector(gotoServices(sender:)), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(backgroundButton)
            
            let logoImageView = UIImageView.init(frame: CGRect.init(x: 0, y:(scrollView.frame.height/2 - 70)/2, width: 280, height: 70))
            logoImageView.image = UIImage.init(named: "ic_logo_nav")
            scrollView.addSubview(logoImageView)
            
            let modelNameLabel = UILabel.init(frame: CGRect.init(x: 0, y: (scrollView.frame.height/2 - 30)/2   , width: scrollView.frame.width, height: 30))
            modelNameLabel.textColor = UIColor.white
            modelNameLabel.font = UIFont.systemFont(ofSize: 16)
            modelNameLabel.text = modelNameArray[index]
            modelNameLabel.textAlignment = .center
            scrollView.addSubview(modelNameLabel)
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
