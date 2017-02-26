//
//  labelEditViewController.swift
//  Alarm-ios8-swift
//
//  Created by longyutao on 15/10/21.
//  Copyright (c) 2015年 LongGames. All rights reserved.
//

import UIKit

class LabelEditViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var labelTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTextField.becomeFirstResponder()
        // Do any additional setup after loading the view.
        self.labelTextField.delegate = self
        
        labelTextField.text = Global.label
        
        //defined in UITextInputTraits protocol
        labelTextField.returnKeyType = UIReturnKeyType.done
        labelTextField.enablesReturnKeyAutomatically = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ///
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: "~ \(type(of: self))")
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        
        Global.label = textField.text!

        //Becuase segue push is used
        navigationController?.popViewController(animated: true)
        return false
    }

}
