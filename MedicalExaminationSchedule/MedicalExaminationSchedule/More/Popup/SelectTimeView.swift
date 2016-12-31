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

    @IBOutlet weak var bodyView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var minutesPickerView: UIPickerView!
    var arrayHour = [String]()
    var arrayMinutes = [String]()
    var currentHours = "00"
    var currentMinutes = "00"
    
    var closePop : SelectTimeViewClose?
    var saveData : SelectTimeViewSave?
    
    @IBAction func tappedSaveButton(_ sender: Any) {
        
        saveData!(String.init(format: "%@:%@", currentHours,currentMinutes))
    }
    @IBAction func tappedHiddenButton(_ sender: Any) {
        closePop!()
    }
    
    func setupView(saveAction : @escaping SelectTimeViewSave, closeAction: @escaping SelectTimeViewClose) -> Void {
        ProjectCommon.boundView(button: bodyView, cornerRadius: 5.0, color: UIColor.clear, borderWith: 0)
        for i in 0..<24 {
            arrayHour.append(String.init(format: "%d", i))
        }
        for i in 0..<4 {
            arrayMinutes.append(String.init(format: "%d", i*15))
        }
        pickerView.reloadAllComponents()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        minutesPickerView.reloadAllComponents()
        minutesPickerView.delegate = self
        minutesPickerView.dataSource = self
        closePop = closeAction
        saveData = saveAction
    }
    
    func showPop(hours:String, minutes:String) -> Void {
        let indexHours = Int(hours)!
        currentHours = hours
        let indexMinutes = Int(minutes)!/15
        currentMinutes = minutes
        pickerView.selectRow(indexHours, inComponent: 0, animated: true)
        minutesPickerView.selectRow(indexMinutes, inComponent: 0, animated: true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return arrayHour.count
        }else {
            return arrayMinutes.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return arrayHour[row]
        }else {
            return arrayMinutes[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0 {
            // hours
            currentHours = arrayHour[row]
        }else {
            // minutes
            currentMinutes = arrayMinutes[row]
        }
    }
}
