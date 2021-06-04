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

class AddAlarmCtrl: UIViewController {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var addAlarmPopupTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryColorTag: UIImageView!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var repeatView: UIView!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var frequencyLabel: UILabel!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationPickerView: UISegmentedControl!
    @IBOutlet weak var detailField: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preSetup()
        themeChanged()
    }
    
    func preSetup() {
        addAlarmPopupTitle.text = "Add Alarm"
        addAlarmPopupTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtn_Tapped), for: .touchUpInside)
        
        saveBtn.setTitle("Save", for: .normal)
        
        categoryTitle.text = "Tennis"
        categoryTitle.font = FontSizeControl.currentFontSize.cellTextSize
        
        timeLabel.font = FontSizeControl.currentFontSize.cellTextSize
        timeLabel.text = "Time"
        
        repeatLabel.font = FontSizeControl.currentFontSize.cellTextSize
        repeatLabel.text = "Repeat"
        
        locationLabel.font = FontSizeControl.currentFontSize.cellTextSize
        locationLabel.text = "Location"
        
        frequencyLabel.font = FontSizeControl.currentFontSize.versionInfoLabel
        frequencyLabel.text = "Mon, Wed, Thu, Fri"
        
        nextBtn.setImage(UIImage(named: "next")?.withRenderingMode(.alwaysTemplate), for: .normal)
        nextBtn.addTarget(self, action: #selector(nextBtn_Tapped), for: .touchUpInside)
        nextBtn.tintColor = Theme.currentTheme.accentColor
        
        detailField.customTextView()
        detailField.font = FontSizeControl.currentFontSize.add_fieldTextSize
        detailField.text = "Pre-set details of your activity. (optional)"
    }
    
    func themeChanged() {
        self.view.backgroundColor = Theme.currentTheme.backgroundColor
        containerView.backgroundColor = Theme.currentTheme.backgroundColor
        timeView.backgroundColor = Theme.currentTheme.lightCellColor
        repeatView.backgroundColor = Theme.currentTheme.lightCellColor
        locationView.backgroundColor = Theme.currentTheme.lightCellColor
        detailField.backgroundColor = Theme.currentTheme.tagCellColor
        
        addAlarmPopupTitle.textColor = Theme.currentTheme.headerTitleColor
        categoryTitle.textColor = Theme.currentTheme.headerTitleColor
        timeLabel.textColor = Theme.currentTheme.headerTitleColor
        repeatLabel.textColor = Theme.currentTheme.headerTitleColor
        locationLabel.textColor = Theme.currentTheme.headerTitleColor
        frequencyLabel.textColor = Theme.currentTheme.headerTitleColor
        
        categoryColorTag.layer.cornerRadius = categoryColorTag.layer.frame.width / 2
        
        detailField.textColor = Theme.currentTheme.opacityText
        
        cancelBtn.tintColor = Theme.currentTheme.opacityText
        saveBtn.tintColor = Theme.currentTheme.accentColor
        
    }
    
    // MARK:- Set Alarm
    func setAlarm() {
        /// 1. Ask the user for permission
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
        }
        
        /// 2. Create the notification content
        let content = UNMutableNotificationContent()
        content.title = "This is the title of notification"
        content.body = "This is the body sentence of the notification"
        
        /// 3.Create the notification trigger
        let date = Date().addingTimeInterval(15)
        
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        /// 4. Create the request
        let uuidString = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
        /// 5. Register the request
        center.add(request) { (error) in
            /// Check the error parameter and handle any errors
        }
    }
    
    // MARK:- Next Button Touch

    @objc func nextBtn_Tapped() {
//        let vc = storyboard?.instantiateViewController(identifier: "removeAds") as! IAPController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func saveBtn_Tapped(_ sender: UIButton) {
        
    }
    
    @objc func cancelBtn_Tapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
