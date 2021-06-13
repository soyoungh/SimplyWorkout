//
//  AddAlarmCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2021/06/03.
//  Copyright © 2021 soyoung hyun. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

protocol AddAlarmData {
    func addAlarmData (alarm_activityTile: String, alarm_location: String, alarm_freqeuncy: String, alarm_detail: String, alarm_isnotified: Bool)
}

class AddAlarmCtrl: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addAlarmPopupTitle: UILabel!
    @IBOutlet weak var categoryColorTag: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPickerView: UISegmentedControl!
    @IBOutlet weak var detailField: UITextView!
    @IBOutlet weak var monBtn: UIButton!
    @IBOutlet weak var tueBtn: UIButton!
    @IBOutlet weak var wedBtn: UIButton!
    @IBOutlet weak var thuBtn: UIButton!
    @IBOutlet weak var friBtn: UIButton!
    @IBOutlet weak var satBtn: UIButton!
    @IBOutlet weak var sunBtn: UIButton!
    
    /// Localization Labels
    var lo_gym = NSLocalizedString("a_Gym", comment: "addv_locationLabel")
    var lo_home = NSLocalizedString("a_Home", comment: "addv_locationLabel")
    var lo_outside = NSLocalizedString("a_Outside", comment: "addv_locationLabel")
    
    /// day of the week
    var mon = NSLocalizedString("aac_mon", comment: "addAlarm_mon")
    var tue = NSLocalizedString("aac_tue", comment: "addAlarm_tue")
    var wed = NSLocalizedString("aac_wed", comment: "addAlarm_wed")
    var thu = NSLocalizedString("aac_thu", comment: "addAlarm_thu")
    var fri = NSLocalizedString("aac_fri", comment: "addAlarm_fri")
    var sat = NSLocalizedString("aac_sat", comment: "addAlarm_sat")
    var sun = NSLocalizedString("aac_sun", comment: "addAlarm_sun")
    
    /// localization label
    var al_detailField = NSLocalizedString("Pre-set details of your activity. (optional)", comment: "al_detailField Placeholder")
    
    /// sending data
    var al_detailLabel: String?
    var al_locationLabel: String?
    var daysOfWeekSelected: String?
    var repeatationArray = [Int]()
 
    /// StatusBar Preference Setting
    var isDarkContentBackground = true
    var basedDeviceSetting = false
    
    var addAlarmDataDelegate: AddAlarmData?
    
    @IBAction func saveBtn_Tapped(_ sender: Any) {
        addAlarmData()
    }
    
    @IBAction func locationSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            al_locationLabel = lo_gym
        }
        else if sender.selectedSegmentIndex == 1 {
            al_locationLabel = lo_home
        }
        else if sender.selectedSegmentIndex == 2 {
            al_locationLabel = lo_outside
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preSetup()
        isDarkModeOrNot()
        themeChanged()
        
        detailField.delegate = self
    }
    
    func preSetup() {
        addAlarmPopupTitle.text = "Add Alarm"
        addAlarmPopupTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtn_Tapped), for: .touchUpInside)
        
        saveBtn.setTitle("Save", for: .normal)

        categoryTitle.font = FontSizeControl.currentFontSize.cellTextSize
        
        timeLabel.font = FontSizeControl.currentFontSize.cellTextSize
        timeLabel.text = "Time"
        
        repeatLabel.font = FontSizeControl.currentFontSize.cellTextSize
        repeatLabel.text = "Repeat"
        
        locationLabel.font = FontSizeControl.currentFontSize.cellTextSize
        locationLabel.text = "Location"
        
        detailField.customTextView()
        detailField.font = FontSizeControl.currentFontSize.add_fieldTextSize
        detailField.text = al_detailField
        
        monBtn.setTitle(mon, for: .normal)
        monBtn.dayoftheWeekBtn()
        monBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        tueBtn.setTitle(tue, for: .normal)
        tueBtn.dayoftheWeekBtn()
        tueBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        wedBtn.setTitle(wed, for: .normal)
        wedBtn.dayoftheWeekBtn()
        wedBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        thuBtn.setTitle(thu, for: .normal)
        thuBtn.dayoftheWeekBtn()
        thuBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        friBtn.setTitle(fri, for: .normal)
        friBtn.dayoftheWeekBtn()
        friBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        satBtn.setTitle(sat, for: .normal)
        satBtn.dayoftheWeekBtn()
        satBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        sunBtn.setTitle(sun, for: .normal)
        sunBtn.dayoftheWeekBtn()
        sunBtn.addTarget(self, action: #selector(toggleAction(_:)), for: .touchUpInside)
        
        locationPickerView.setTitle(lo_gym, forSegmentAt: 0)
        locationPickerView.setTitle(lo_home, forSegmentAt: 1)
        locationPickerView.setTitle(lo_outside, forSegmentAt: 2)
    }
    
    func themeChanged() {
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        timeView.backgroundColor = Theme.currentTheme.lightCellColor
        repeatView.backgroundColor = Theme.currentTheme.lightCellColor
        locationView.backgroundColor = Theme.currentTheme.lightCellColor
        detailField.backgroundColor = Theme.currentTheme.tagCellColor
        
        addAlarmPopupTitle.textColor = Theme.currentTheme.headerTitleColor
        categoryTitle.textColor = Theme.currentTheme.headerTitleColor
        timeLabel.textColor = Theme.currentTheme.headerTitleColor
        repeatLabel.textColor = Theme.currentTheme.headerTitleColor
        locationLabel.textColor = Theme.currentTheme.headerTitleColor

        categoryColorTag.layer.cornerRadius = categoryColorTag.layer.frame.width / 2
        
        detailField.textColor = Theme.currentTheme.opacityText
        
        cancelBtn.tintColor = Theme.currentTheme.opacityText
        saveBtn.tintColor = Theme.currentTheme.accentColor
        
        locationPickerView.selectedSegmentTintColor = Theme.currentTheme.segmentColor
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.currentTheme.opacityText], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Theme.currentTheme.textColor], for: .selected)
        
        if isDarkContentBackground {
            timePicker.overrideUserInterfaceStyle = .dark
        }
        else if basedDeviceSetting {
            timePicker.overrideUserInterfaceStyle = .unspecified
        }
        else {
            timePicker.overrideUserInterfaceStyle = .light
        }
    }
    
    func isDarkModeOrNot() {
        if !UserDefaults.standard.bool(forKey: "DarkTheme") {
            // lightTheme
            isDarkContentBackground = false
        }
        else {
            isDarkContentBackground = true
        }
        
        if !UserDefaults.standard.bool(forKey: "AutoMode") {
            basedDeviceSetting = false
        }
        else {
            basedDeviceSetting = true
        }
    }
    
    // MARK:- AddAlarm Data
    func addAlarmData() {
        guard let del = addAlarmDataDelegate else { return }
        nilValueCheck()
        del.addAlarmData(alarm_activityTile:categoryTitle.text!, alarm_location: al_locationLabel ?? lo_gym, alarm_freqeuncy: daysOfWeekSelected!, alarm_detail: al_detailLabel!, alarm_isnotified: true)
        setAlarm()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func nilValueCheck() {
        if detailField.text == al_detailField {
            al_detailLabel = "  "
        }
        else {
            al_detailLabel = detailField.text
        }
        
        /// update the location data
        if al_locationLabel == lo_gym {
            locationPickerView.selectedSegmentIndex = 0
        }
        else if al_locationLabel == lo_home {
            locationPickerView.selectedSegmentIndex = 1
        }
        else if al_locationLabel == lo_outside {
            locationPickerView.selectedSegmentIndex = 2
        }
        
    }
    
    // MARK:- Set Alarm
    func setAlarm() {
        /// 1. Ask the user for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        /// 2. Create the notification content
        let content = UNMutableNotificationContent()
        content.title = categoryTitle.text!
        content.body = al_detailLabel!
        
        /// 3.Create the notification trigger
        let date = timePicker.date
        let components = Calendar.current.dateComponents([.weekday, .hour, .minute], from: date)
       
        for i in repeatationArray {
            
            var dateComponents = DateComponents()
            dateComponents.hour = components.hour
            dateComponents.minute = components.minute
            
            /// Sunday = 1, Monday = 2, Tuesday = 3, Wednesday = 4, thursday = 5, Friday = 6, Saturday = 7
            dateComponents.weekday = i
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            /// 4. Create the request
            let uuidString = "UA_" + "\(categoryTitle.text!)"
            
            let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
            
            /// 5. Register the request
            center.add(request) { (error) in
                /// Check the error parameter and handle any errors
            }
        }
    }

    @objc func cancelBtn_Tapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func toggleAction(_ sender: UIButton) {
        sender.isSelected.toggle()
        
        if sender.isHighlighted && sender.isSelected{
            sender.backgroundColor = Theme.currentTheme.accentColor
            if daysOfWeekSelected == nil || daysOfWeekSelected == "" {
                daysOfWeekSelected = sender.titleLabel!.text!
            }
            else {
                daysOfWeekSelected!.append(", " + sender.titleLabel!.text!)
            }
            repeatationArray.append(frequencyChecks(sender))
//            print(daysOfWeekSelected!)
//            print(repeatationArray)
        }
        else if !sender.isHighlighted && sender.isSelected {
            sender.backgroundColor = Theme.currentTheme.accentColor
        }
        else if sender.isHighlighted && !sender.isSelected {
            sender.backgroundColor = Theme.currentTheme.dayOfTheWeekBtnColor
            if daysOfWeekSelected!.contains(",") {
                daysOfWeekSelected = daysOfWeekSelected!
                    .replacingOccurrences(of: ", " + sender.titleLabel!.text!, with: "")
                    }
            else {
                daysOfWeekSelected = daysOfWeekSelected!
                    .replacingOccurrences(of: sender.titleLabel!.text!, with: "")
            }
            
            if let index = repeatationArray.firstIndex(of: frequencyChecks(sender)) {
                repeatationArray.remove(at: index)
            }
//            print(daysOfWeekSelected!)
//            print(repeatationArray)
        }
        else {
            sender.backgroundColor = Theme.currentTheme.dayOfTheWeekBtnColor
        }
    }
 
    func frequencyChecks(_ sender: UIButton) -> Int {
        if sender.titleLabel!.text?.contains(mon) == true {
            return 2
        }
        else if sender.titleLabel!.text?.contains(tue) == true {
            return 3
        }
        else if sender.titleLabel!.text?.contains(wed) == true {
            return 4
        }
        else if sender.titleLabel!.text?.contains(thu) == true {
            return 5
        }
        else if sender.titleLabel!.text?.contains(fri) == true {
            return 6
        }
        else if sender.titleLabel!.text?.contains(sat) == true {
            return 7
        }
        else if sender.titleLabel!.text?.contains(sun) == true {
            return 1
        }
        else {
            return 0
        }
    }
    
    private func confitureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UITextField Delegation
extension AddAlarmCtrl: UITextFieldDelegate, UITextViewDelegate {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        confitureTapGesture()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        /// Combine the textView text and the replacement text to create the updated text string
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: NSRangeFromString(al_detailField), with: text)
        /// If updated text view will be empty, add the placeholder and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        }
            /// Else if the text view's placeholder is showing and the length of the replacement string is greater than 0, set the text color to black then set its text to the replacement string
        else if textView.textColor == UIColor.systemGray2 && !text.isEmpty {
            textView.textColor = Theme.currentTheme.textColor
            textView.text = text
        }
        else if textView.textColor == UIColor.darkGray && !text.isEmpty {
            textView.textColor = Theme.currentTheme.textColor
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
