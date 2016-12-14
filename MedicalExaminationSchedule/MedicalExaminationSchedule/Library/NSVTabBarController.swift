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

        if self.navigationController?.viewControllers.count == 1 {
            var navigationViewControllers = self.navigationController?.viewControllers
            let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = mainStoryBoard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
            navigationViewControllers?.insert(loginViewController, at: 0)
            self.navigationController?.viewControllers = navigationViewControllers!
        }
        // Do any additional setup after loading the view.
        self.delegate = self
        
        //*****// TabBar Icons Customization //*****//
        
        // To Create the TabBar icons as NSArray
        
        let imagesArray : NSArray = ["ic_news","ic_location_map","ic_time","ic_more",]
        // To Create the TabBar icons as NSArray for selection time

//        let  selecteimgArray:NSArray = ["home_selected.png","maps_selected.png","myplan_selected.png","settings_selected.png","maps_selected.png"]
        // Customize the tabBar images

        //*****//*****//*****//*****//*****//*****//*****//*****//
        
        //****// TabBar Title Customization //*****//
        
        // To Create the attribute dictionary for title for color and font
        NSVBarController.setTabbar(self.tabBar, images:imagesArray, selectedImages: imagesArray)
        
        // Customize the tabBar title
                let attributes = [NSForegroundColorAttributeName:UIColor.white]
         NSVBarController.setTabBarTitleColor(attributes as AnyObject)
         //*****//*****//*****//*****//*****//*****//*****//*****//
    }
    
    override func viewDidLayoutSubviews() {
        let imagesArray : NSArray = ["ic_news","ic_location_map","ic_time","ic_more",]
        // To Create the TabBar icons as NSArray for selection time
        
        //        let  selecteimgArray:NSArray = ["home_selected.png","maps_selected.png","myplan_selected.png","settings_selected.png","maps_selected.png"]
        // Customize the tabBar images
        
        //*****//*****//*****//*****//*****//*****//*****//*****//
        
        //****// TabBar Title Customization //*****//
        
        // To Create the attribute dictionary for title for color and font
        NSVBarController.setTabbar(self.tabBar, images:imagesArray, selectedImages: imagesArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
         //****// TabBar Images Animations //*****//
//         NSVBarController.setAnimation(tabBarController, animationtype:selectedAnimation)
        //*****//*****//*****//*****//*****//*****//*****//*****//

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
