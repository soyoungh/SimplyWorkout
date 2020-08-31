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
    @IBOutlet weak var detailField: UITextView!
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
        
        activityFiled.delegate = self
        detailField.delegate = self
    }

    // MARK: - make rounded corners of view layers and drop shadow
    private func viewLayerSet() {
        activityFiled.placeholder = "Add an activity title here."
        doneBtn.titleLabel!.text = "Done"
        
        colorTagView.customView()
        cancelBtn.roundedCornerBtn()
        doneBtn.roundedCornerBtn()
        
        activityFiled.layer.borderColor = UIColor.systemGray4.cgColor
        activityFiled.layer.borderWidth = 1
        
        detailField.customTextView()
        detailField.font = UIFont.systemFont(ofSize: 14.0)
        detailField.text = "Give some details.(optional)"
        detailField.textColor = UIColor.systemGray3
    }
    
    func dismissCheck() {
        /// Activity and detail Field Check First!
        if activityFiled.text != "" || detailField.text != "Give some details.(optional)" {
            /// Save datas and deliver the blief to the table View
            guard let del = addDataDelegate else {
                return
            }
            nilValueCheck()
            del.addWorkoutData(activity: activityLabel!, detail: detailLabel!, effortType: effortLabel!, duration: durationLabel!, colorType: colorTagCtrl.selectedColor ?? "butterRum", location: locationLabel ?? " Gym ")

            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func nilValueCheck() {
        /// check for the activity Label
        if activityFiled.text == "" {
            activityLabel = "  "
        }
        else {
            activityLabel = activityFiled.text
        }
        
        ///check for the detail Label
        if detailField.text == "Give some details.(optional)" {
            detailLabel = "  "
        }
        else {
            detailLabel = detailField.text
        }
        
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
    
    private func confitureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UITextField Delegation
extension AddViewController: UITextFieldDelegate, UITextViewDelegate {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        confitureTapGesture()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activityFiled.resignFirstResponder()
        return true
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// Combine the textView text and the replacement text to create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        /// If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
        /// Else if the text view's placeholder is showing and the length of the replacement string is greater than 0, set the text color to black then set its text to the replacement string
         else if textView.textColor == UIColor.systemGray3 && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        }
        /// For every other case, the text should change with the usual behavior...
        else {
            return true
        }
        /// ...otherwise return false since the updates have already been made
        return false
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
            return 50
        }
        else {
            return 170
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

