//
//  CategorySettingCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/24.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit
import CoreData

class CategorySettingCtrl: UIViewController, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var categoryTable: UITableView!
    
    var backIcon: UIImage!
    var categoryAddPopupCtrl = CategoryAddPopupCtrl()
    var categoryArray = [CategoryCD]()
    var selectedCategoryArray = [CategoryCD]()
    
    /// Localization Labels
    var co_gym = NSLocalizedString("co_Gym", comment: "cateSet_locationLabel")
    var co_home = NSLocalizedString("co_Home", comment: "cateSet_locationLabel")
    var co_outside = NSLocalizedString("co_Outside", comment: "cateSet_locationLabel")
    
    /// day of the week
    var cateSetmon = NSLocalizedString("cateSet_mon", comment: "cateSet_mon")
    var cateSettue = NSLocalizedString("cateSet_tue", comment: "cateSet_tue")
    var cateSetwed = NSLocalizedString("cateSet_wed", comment: "cateSet_wed")
    var cateSetthu = NSLocalizedString("cateSet_thu", comment: "cateSet_thu")
    var cateSetfri = NSLocalizedString("cateSet_fri", comment: "cateSet_fri")
    var cateSetsat = NSLocalizedString("cateSet_sat", comment: "cateSet_sat")
    var cateSetsun = NSLocalizedString("cateSet_sun", comment: "cateSet_sun")
    
    /// CoreData Stack
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// StatusBar Preference Setting
    var isDarkContentBackground = false
    var basedDeviceSetting = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if isDarkContentBackground {
            return .lightContent
        }
        else if basedDeviceSetting {
            return .default
        }
        else {
            return .darkContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        fetchAndUpdateData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetup()
        setupNavBar()
        isDarkModeOrNot()
        applyTheme()
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
    
    func presetup() {
        backIcon = UIImage(named: "leftArrow")
        let tempImg = backIcon.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tempImg, for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        categoryTable.tableFooterView = UIView()
        categoryTable.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        plusBtn.addTarget(self, action: #selector(plusBtnDidTapped), for: .touchUpInside)
        categoryTable.dataSource = self
        categoryTable.delegate = self
    }
    
    @objc func backBtnTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "settingPage") as! ConfigurationsController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func plusBtnDidTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "categoryAddPopup") as! CategoryAddPopupCtrl
        self.navigationController?.present(vc, animated: true)
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        vc.addCategoryDelegate = self
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        backBtn.tintColor = Theme.currentTheme.accentColor
        plusBtn.tintColor = Theme.currentTheme.accentColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        categoryTable.backgroundColor = Theme.currentTheme.backgroundColor
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        navTitle.text = NSLocalizedString("cs_Category Settings", comment: "enter the category setting page")
        navTitle.alpha = 0.7
    }
    
    func fetchAndUpdateData() {
        let request = CategoryCD.createFetchRequest()
        let sort = NSSortDescriptor(key: "index", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            categoryArray = try context.fetch(request)
            selectedCategoryArray.removeAll()
            DispatchQueue.main.async {
                self.categoryTable.reloadData()
            }
        }
        catch {
            print("Fetch failed - category setting")
        }
    }
}

extension CategorySettingCtrl: AddCategory {
    func addCategoryData(activityName: String, colorTag: String) {
        
        let categoryData = CategoryCD(context: context)
        categoryData.activityName_c = activityName
        categoryData.colorTag_c = colorTag
        
        /// save the data
        do {
            try self.context.save()
        }
        catch {
        }
        
        /// Re-Fetch the data
        fetchAndUpdateData()
    }
}

extension CategorySettingCtrl: AddAlarmData {
    func addAlarmData(alarm_activityTile: String, alarm_location: String, alarm_freqeuncy: String, alarm_detail: String, alarm_isnotified: Bool, alarm_hour: String, alarm_minute: String) {
        
        if selectedCategoryArray.isEmpty == true {
            for data in categoryArray {
                if data.activityName_c == alarm_activityTile {
                    data.location = alarm_location
                    data.frequency = alarm_freqeuncy
                    data.preSet_details = alarm_detail
                    data.isNotified = alarm_isnotified
                    data.alarm_hour = alarm_hour
                    data.alarm_minute = alarm_minute
                }
            }
        }
        else {
            /// Update the data array
            for data in selectedCategoryArray {
                if data.activityName_c == alarm_activityTile {
                    data.location = alarm_location
                    data.frequency = alarm_freqeuncy
                    data.preSet_details = alarm_detail
                    data.isNotified = alarm_isnotified
                    data.alarm_hour = alarm_hour
                    data.alarm_minute = alarm_minute
                }
            }
        }

        /// save the data
        do {
            try self.context.save()
        }
        catch {
        }
        
        /// Re-Fetch the data
        fetchAndUpdateData()
    }
}


extension CategorySettingCtrl: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategorySetViewCell
        let category = categoryArray[indexPath.row]
        cell.categoryData = category
        cell.backgroundColor = Theme.currentTheme.backgroundColor
        cell.selectionStyle = .none
        
        cell.alarm_LocalTitle.isHidden = category.isNotified ? false : true
        cell.alarm_closure_Icon.isHidden = category.isNotified ? false : true
        cell.repeat_label.isHidden = category.isNotified ? false : true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let notification = notificationAction(at: indexPath)
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [notification, delete])
    }
    
    func notificationAction(at indexPath: IndexPath) -> UIContextualAction {
        let category = categoryArray[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "notification") { (action, view, completion) in
            
            switch category.isNotified {
            case true:
                /// if category.isNotified is true,  open up the pop up window for delete the notification.
                self.cancelAlarmAction(category.activityName_c!, alertTitle: NSLocalizedString("Delete this scheduled alarm", comment: "al_removeAlarm - title"), alertMessage: NSLocalizedString("The alarm of the catrgory will be deleted. \nDo you want to continue?", comment: "al_removeAlarm - body"), indexPath: indexPath)
                
            case false:
                /// if category.isNorified is false, pop up the settting page of notifications
                let vc = self.storyboard?.instantiateViewController(identifier: "alarmSetting") as! AddAlarmCtrl
                vc.addAlarmDataDelegate = self
                self.navigationController?.present(vc, animated: true)
                vc.categoryTitle.text = category.activityName_c
                vc.categoryColorTag.backgroundColor = UIColor(named: category.colorTag_c!)
                self.categoryTable.reloadData()
            /// when the slide menu closes, remark the schedule icon next to the category title.
            }
            completion(true)
        }
        
        action.image = category.isNotified ? UIImage(systemName: "bell.slash"): UIImage(systemName: "bell")
        action.backgroundColor = category.isNotified ? .systemGray : .systemGreen
        
        return action
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let category = categoryArray[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "delete") { (action, view, completion) in
            
            self.context.delete(category)
            
            /// delete the local norification, if it set
            self.removeAlarm(uuidString: category.activityName_c)
            
            /// save the data
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchAndUpdateData()
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemRed
        return action
    }
    
    func cancelAlarmAction(_ categoryTitle: String, alertTitle: String, alertMessage: String, indexPath: IndexPath) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        let mainTask = UIAlertAction(title: NSLocalizedString("Confirm", comment: "al_removeAlarm - done button"), style: .default) { (_) in
            
            let category = self.categoryArray[indexPath.row]
            category.isNotified = false
            
            /// delete the local norification, if it set
            self.removeAlarm(uuidString: category.activityName_c)
            
            /// save the data
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchAndUpdateData()
        }
        let cancelTask = UIAlertAction(title: NSLocalizedString("al_ra_cancel", comment: "al_removealarm- cancel button"), style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(mainTask)
        alert.addAction(cancelTask)
        present(alert, animated:true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = storyboard?.instantiateViewController(identifier: "alarmSetting") as! AddAlarmCtrl
        let categoryData = categoryArray[indexPath.row]
        
        if categoryData.isNotified {
            
            selectedCategoryArray.append(categoryData)
            self.present(vc, animated: true, completion: nil)
            vc.saveBtn.setTitle(NSLocalizedString("al_update", comment: "al_updateBtn_title"), for: .normal)
            
            /// update the data
            vc.categoryTitle.text = categoryData.activityName_c
            vc.categoryColorTag.backgroundColor = UIColor(named: categoryData.colorTag_c!)
            vc.al_locationLabel = categoryData.location
            vc.detailField.text = categoryData.preSet_details!
            vc.detailField.textColor! = Theme.currentTheme.textColor
            vc.daysOfWeekSelected = categoryData.frequency
            vc.al_hour = Int(categoryData.alarm_hour!)
            vc.al_minute = Int(categoryData.alarm_minute!)
            
            /// update the clock
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            if let date = dateFormatter.date(from: "\(categoryData.alarm_hour!):\(categoryData.alarm_minute!)") {
                vc.timePicker.date = date
            }
            
            /// update the location
            if categoryData.location == co_gym {
                vc.locationPickerView.selectedSegmentIndex = 0
            }
            else if categoryData.location == co_home {
                vc.locationPickerView.selectedSegmentIndex = 1
            }
            else if categoryData.location == co_outside {
                vc.locationPickerView.selectedSegmentIndex = 2
            }
            
            /// update the frequency
            let frequency = categoryData.frequency?.byWords
            
            for i in frequency! {
                switch i {
                case cateSetmon:
                    vc.toggleAction(vc.monBtn)
                case cateSettue:
                    vc.toggleAction(vc.tueBtn)
                case cateSetwed:
                    vc.toggleAction(vc.wedBtn)
                case cateSetthu:
                    vc.toggleAction(vc.thuBtn)
                case cateSetfri:
                    vc.toggleAction(vc.friBtn)
                case cateSetsat:
                    vc.toggleAction(vc.satBtn)
                case cateSetsun:
                    vc.toggleAction(vc.sunBtn)
                default:
                    break
                }
            }
            
            vc.addAlarmDataDelegate = self
        }
    }
    
    func removeAlarm(uuidString: String?) {
        
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { (notifications) in
            for item in notifications {
                if let uuidID = uuidString {
                    if item.identifier.contains(uuidID) {
                        
                        center.removeDeliveredNotifications(withIdentifiers: [item.identifier])
                        center.removePendingNotificationRequests(withIdentifiers: [item.identifier])
                    }
                }
//                print("Remove the pending alarm's id: " + item.identifier)
            }
        }
        
        center.getDeliveredNotifications { (notifications) in
            for item in notifications {
                if let uuidID = uuidString {
                    if item.request.identifier.contains(uuidID) {
                        center.removeDeliveredNotifications(withIdentifiers: [item.request.identifier])
                        center.removePendingNotificationRequests(withIdentifiers: [item.request.identifier])
                    }
                }
//                print("Remove the delivered alarm's id: " + item.request.identifier)
            }
        }
    }
}
