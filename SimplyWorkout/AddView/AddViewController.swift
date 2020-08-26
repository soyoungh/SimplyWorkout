//
//  AddViewController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 14/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

protocol AddData {
    func addWorkoutData (activity: String, detail: String, effortType: String, duration: String, colorType: String, location: String)
}

class AddViewController: UIViewController {
    
    @IBOutlet weak var colorTagView: UICollectionView!
    @IBOutlet weak var effortPickView: UIPickerView!
    @IBOutlet weak var durationPickView: UIPickerView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var activityFiled: UITextField!
    @IBOutlet weak var detailField: UITextField!
    @IBOutlet weak var locationPickView: UISegmentedControl!
    
    /// Sending Datas
    var addDataDelegate: AddData?
    var activityLabel: String?
    var detailLabel: String?
    var effortLabel: String?
    var durationLabel: String?
    var locationLabel: String?
    
    /// DurationPickerView Properties
    var durationString: String?
    let hoursNum = Array(0...24)
    let minuteNum = Array(0...59)

    /// Related Controller Connection
    var effortScaleCtrl = EffortScalePicker()
    var colorTagCtrl = ColorTagCtrl()
    var progressBarCtrl = ProgressBar()
    var firstSelectionIndexPath: IndexPath?
    var isFilled: Bool = false
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        dismissCheck()
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            locationLabel = " Gym "
        }
        else if sender.selectedSegmentIndex == 1 {
            locationLabel = " Home "
        }
        else if sender.selectedSegmentIndex == 2 {
            locationLabel = " Outside "
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewLayerSet()
        
        effortPickView.dataSource = effortScaleCtrl
        effortPickView.delegate = effortScaleCtrl
        effortPickView.selectRow(2, inComponent: 0, animated: false)
        
        colorTagView.dataSource = colorTagCtrl
        colorTagView.delegate = colorTagCtrl
        
        durationPickView.delegate = self
        durationPickView.dataSource = self
        
        durationPickView.selectRow(0, inComponent: 0, animated: true)
        durationPickView.selectRow(0, inComponent: 2, animated: true)
        
    }

    // MARK: - make rounded corners of view layers and drop shadow
    private func viewLayerSet() {
        activityFiled.placeholder = "Add an activity title here."
        detailField.placeholder = "Give some detailes. (optional)"
        doneBtn.titleLabel!.text = "Done"
        
        colorTagView.customView()
        cancelBtn.roundedCornerBtn()
        doneBtn.roundedCornerBtn()
    }
    
    func dismissCheck() {
        /// Activity and detail Field Check First!
        if activityFiled?.text != "" || detailField.text != "" {
            /// Save datas and deliver the blief to the table View
            guard let del = addDataDelegate else {
                return
            }
            activityLabel = activityFiled.text
            detailLabel = detailField.text
            nilValueCheck()
            del.addWorkoutData(activity: activityLabel!, detail: detailLabel!, effortType: effortLabel!, duration: durationLabel!, colorType: colorTagCtrl.selectedColor ?? "butterRum", location: locationLabel ?? " Gym ")
            
            /// TO DO: Create an event on the calendar
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func nilValueCheck() {
        /// check for the Duration Label
        if durationString == nil {
            durationLabel = "0h 0min"
        }
        else {
            durationLabel = durationString!
        }

        /// check for the Effort Scale Label
        if effortScaleCtrl.userEffortScale == nil {
            effortLabel = "Moderate"
        }
        else {
            effortLabel = effortScaleCtrl.userEffortScale!
        }
    }
}

// MARK: - Duration PickerView Delegation
extension AddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return hoursNum.count
        }
        else if component == 1 {
            return 1
        }
        else if component == 2 {
            return minuteNum.count
        }
        else {
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return String(hoursNum[row])
        }
        else if component == 1 {
            return ""
        }
        else if component == 2 {
            return String(minuteNum[row])
        }
        else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        
        if component == 0 {
            return 100
        }
        else if component == 1 {
            return 40
        }
        else if component == 2 {
            return 40
        }
        else {
            return 180
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        
        switch component {
        case 0:
            pickerLabel.text = String(hoursNum[row])
            pickerLabel.textAlignment = .right
        case 1:
            pickerLabel.text = ""
        case 2:
            pickerLabel.text = String(minuteNum[row])
            pickerLabel.textAlignment = .right
        case 3:
            pickerLabel.text = ""
            
        default: break
        }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let hour = hoursNum[pickerView.selectedRow(inComponent: 0)]
        let min = minuteNum[pickerView.selectedRow(inComponent: 2)]
  
        if hour == 0 && min != 0 {
            durationString = "\(min)min"
        }
        else if hour != 0 && min == 0 {
            durationString = "\(hour)h"
        }
        else if hour != 0 && min != 0 {
            durationString = "\(hour)h \(min)min"
            //print("both")
        }
        else {
            return
        }
        
        if hour == 1 {
            hourLabel.text = "hour"
        } else {
            hourLabel.text = "hours"
        }
    }
}

