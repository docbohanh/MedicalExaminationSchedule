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
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        scrollView.contentSize = CGSize.init(width: 4 * scrollView.frame.width, height: scrollView.frame.height)
        
        self.initScrollView()

    }
    func initScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.isDirectionalLockEnabled = true
        for index in 0...3 {
            let logoImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(index) * scrollView.frame.width, y:0, width: scrollView.frame.width, height: scrollView.frame.height))
            let image:String = modelImageArray[index]
            logoImageView.image = UIImage.init(named: image)
            scrollView.addSubview(logoImageView)
            
            let backgroundButton = UIButton.init(type: UIButtonType.custom)
            backgroundButton.frame = CGRect.init(x: CGFloat(index) * scrollView.frame.width, y: (logoImageView.frame.height - 100)/2, width: scrollView.frame.width, height: 100)
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
