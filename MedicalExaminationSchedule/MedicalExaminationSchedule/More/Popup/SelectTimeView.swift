//
//  SelectTimeView.swift
//  MedicalExaminationSchedule
//
//  Created by Thuy Phan on 12/31/16.
//  Copyright © 2016 Nguyen Hai Dang. All rights reserved.
//

import UIKit

typealias SelectTimeViewClose = () -> Void
typealias SelectTimeViewSave = (String) -> Void

class SelectTimeView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    var arrayHour = [String]()
    var arrayMinutes = [String]()
    var hours = "00"
    var minutes = "00"
    
    var closePop : SelectTimeViewClose?
    var saveData : SelectTimeViewSave?
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        closePop!()
    }
    @IBAction func tappedHiddenButton(_ sender: Any) {
        saveData!(String.init(format: "%@:%@", hours,minutes))
    }
    
    func setupView(saveAction : @escaping SelectTimeViewSave, closeAction: @escaping SelectTimeViewClose) -> Void {
        closePop = closeAction
        saveData = saveAction
    }
    
    func showPop(hours:String, minutes:String) -> Void {
        let indexHours = Int(hours)
        let indexMinutes = Int(minutes)!/15
        pickerView.selectRow(indexHours!, inComponent: 0, animated: true)
        pickerView.selectRow(indexMinutes, inComponent: 0, animated: true)
    }
    
    func intView() -> Void {
        for i in 0..<25 {
            arrayHour.append(String.init(format: "%2d", i))
        }
        for i in 0..<5 {
            arrayMinutes.append(String.init(format: "%2d", i*15))
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return arrayHour.count
        }else {
            return arrayMinutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return arrayHour[row]
        }else {
            return arrayMinutes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            // hours
            hours = arrayHour[row]
        }else {
            // minutes
            minutes = arrayHour[row]
        }
    }
}
