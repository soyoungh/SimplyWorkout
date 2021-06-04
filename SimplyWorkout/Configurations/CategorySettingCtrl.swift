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
    
    /// CoreData Stack
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// StatusBar Preference Setting
    var isDarkContentBackground = true
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
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if editingStyle == .delete {
    //            let cell = categoryArray[indexPath.row]
    //            context.delete(cell)
    //            /// save the data
    //            do {
    //                try self.context.save()
    //            }
    //            catch {
    //            }
    //            fetchAndUpdateData()
    //        }
    //    }
    
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
                category.isNotified = false
                self.categoryTable.reloadData()
            case false:
                /// if category.isNorified is false, pop up the settting page of notifications
                self.didTapAlarmIcon()
                category.isNotified = true
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
            /// save the data
            do {
                try self.context.save()
            }
            catch {
            }
            self.fetchAndUpdateData()
            completion(true)
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .systemRed
        return action
    }
    
    func didTapAlarmIcon() {
        let vc = storyboard?.instantiateViewController(identifier: "alarmSetting") as! AddAlarmCtrl
        self.navigationController?.present(vc, animated: true)

    }
}
