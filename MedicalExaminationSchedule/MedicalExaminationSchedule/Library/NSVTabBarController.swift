//
//  NSVTabBarController.swift
//  NSVTabbar-Swift
//
//  Created by srinivas on 7/18/16.
//  Copyright © 2016 Microexcel. All rights reserved.
//

import UIKit


class NSVTabBarController: UITabBarController , UITabBarControllerDelegate{
    
    var selectedAnimation : NSInteger = NSAnimation_FILP_LEFT

    override func viewDidLoad() {
        super.viewDidLoad()
        let revealController = self.revealViewController()
        revealController?.panGestureRecognizer()
        revealController?.tapGestureRecognizer()
        
        if self.navigationController?.viewControllers.count == 1 {
            var navigationViewControllers = self.navigationController?.viewControllers
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            navigationViewControllers?.insert(loginViewController, at: 0)
            self.navigationController?.viewControllers = navigationViewControllers!
        }
        // Do any additional setup after loading the view.
        self.delegate = self
        let newsStoryboard = UIStoryboard.init(name: "News", bundle: nil)
        let newsVC = newsStoryboard.instantiateViewController(withIdentifier: "NewViewController") as! NewViewController
        newsVC.tabBarItem = UITabBarItem.init(title: "Tin tức", image: UIImage.init(named: ""), tag: 0)
        
        //location
        let locationStoryboard = UIStoryboard.init(name: "Locations", bundle: nil)
        let doctorAdrressVC = locationStoryboard.instantiateViewController(withIdentifier: "ServiceViewController") as! ServiceViewController
        doctorAdrressVC.tabBarItem = UITabBarItem.init(title: "Dịch vụ", image: UIImage.init(named: ""), tag: 2)
        
        
        //Schedule
        let scheduleStoryBoard = UIStoryboard.init(name: "Schedule", bundle: nil)
        let doctorHistoryVC = scheduleStoryBoard.instantiateViewController(withIdentifier: "DoctorHistoryViewController") as! DoctorHistoryViewController
        doctorHistoryVC.tabBarItem = UITabBarItem.init(title: "Lịch hẹn", image: UIImage.init(named: ""), tag: 3)
        
        // More
        let moreStoryboard = UIStoryboard.init(name: "More", bundle: nil)
        let moreVC = moreStoryboard.instantiateViewController(withIdentifier: "MoreViewController") as! MoreViewController
        moreVC.tabBarItem = UITabBarItem.init(title: "Thêm", image: UIImage.init(named: ""), tag: 4)
        self.tabBar.backgroundImage = UIImage(named: "tab_bar_background")
        self.viewControllers = [newsVC,doctorAdrressVC, doctorHistoryVC, moreVC]
    }
    
    override func viewDidLayoutSubviews() {

        
        //News
        
        
        // Customize the tabBar title
        let attributes = [NSForegroundColorAttributeName:UIColor.white]
        NSVBarController.setTabBarTitleColor(attributes as AnyObject)
        let imagesArray : NSArray = ["ic_news","ic_location_map","ic_time","ic_more",]
        // To Create the attribute dictionary for title for color and font
        NSVBarController.setTabbar(self.tabBar, images:imagesArray, selectedImages: imagesArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            break;
        case 1:
            break
        default:
            break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func buttonsTouched(_ sender:UIButton){
        selectedAnimation = sender.tag ;
    }

}
