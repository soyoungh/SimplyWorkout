//
//  EffortScalePicker.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 15/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class EffortScalePicker: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var userEffortScale: String?
  
    let effortScale: [String] = [NSLocalizedString("Very Light", comment: "effortPicker"), NSLocalizedString("Light", comment: "effortPicker"), NSLocalizedString("Moderate", comment: "effortPicker"), NSLocalizedString("Vigorous", comment: "effortPicker"), NSLocalizedString("Hard", comment: "effortPicker"), NSLocalizedString("Max", comment: "effortPicker")]

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return effortScale.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return effortScale[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = FontSizeControl.currentFontSize.pickerTextSize
        pickerLabel.textColor = Theme.currentTheme.textColor
        pickerLabel.textAlignment = .center
        pickerLabel.text = effortScale[row]
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        userEffortScale = effortScale[row]
    }
  
}
