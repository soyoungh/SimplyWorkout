//
//  ConfigurationsController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/09/22.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConfigurationsController: UITableViewController {
    
    @IBOutlet var settingTable: UITableView!
    @IBOutlet weak var versionInfo: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    @IBOutlet weak var automaticSwitch: UISwitch!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nextBtn_1: UIButton!
    @IBOutlet weak var nextBtn_2: UIButton!
    @IBOutlet weak var nextBtn_3: UIButton!
    @IBOutlet weak var nextBtn_4: UIButton!
    @IBOutlet weak var nextBtn_5: UIButton!
    @IBOutlet weak var nextBtn_6: UIButton!
    
    var backIcon: UIImage!
    var nextIcon: UIImage!
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    let IAPPurchaseIDs = [["com.soyoungHyun.SimplyWorkout.ncRemoveAds"]]
    let sharedSecret = "c620d1374ee34cd88444245fa7f27e2d"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if Theme.currentTheme.accentColor == UIColor.applyColor(AssetsColor.paleBrown) {
            return .darkContent
        }
        else {
            return .lightContent
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Retrieve state
        let darkModeOnoff = UserDefaults.standard.bool(forKey: "DarkTheme")
        darkModeSwitch.setOn(darkModeOnoff, animated: false)
        
        let autoModeOnoff = UserDefaults.standard.bool(forKey: "AutoMode")
        automaticSwitch.setOn(autoModeOnoff, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preSetup()
        setupNavBar()
        applyTheme()
        
        if !UserDefaults.standard.bool(forKey: "removeAds") {
            // not purchased yet.
            self.darkModeSwitch.alpha = 0.5
            self.automaticSwitch.alpha = 0.5
        }
        else {
            // purchased.
            self.tableView.reloadData()
            self.darkModeSwitch.alpha = 1.0
            self.automaticSwitch.alpha = 1.0
        }
    }

    @objc func automaticSwitchDidChange(_ sender: UISwitch) {
        
        if sender.alpha == 1.0 {
            // Save state
            UserDefaults.standard.set(sender.isOn, forKey: "AutoMode")
            
            if sender.isOn {
                darkModeSwitch.isEnabled = false
                if UITraitCollection.current.userInterfaceStyle == .light || UITraitCollection.current.userInterfaceStyle
                    == .unspecified {
                    Theme.currentTheme = LightTheme()
                }
                else if UITraitCollection.current.userInterfaceStyle == .dark {
                    Theme.currentTheme = DarkTheme()
                }
            }
            else {
                darkModeSwitch.isEnabled = true
                darkModeSwitchDidchange(darkModeSwitch)
            }
            applyTheme()
        }
        else {
            sender.isOn = false
            let vc = storyboard?.instantiateViewController(identifier: "removeAds") as! IAPController
            self.present(vc, animated: true)
        }
    }
    
    @objc func darkModeSwitchDidchange(_ sender: UISwitch) {
        if sender.alpha == 1.0 {
            Theme.currentTheme = sender.isOn ? DarkTheme() : LightTheme()
            UserDefaults.standard.set(sender.isOn, forKey: "DarkTheme")
            applyTheme()
        }
        else  {
            sender.isOn = false
            let vc = storyboard?.instantiateViewController(identifier: "removeAds") as! IAPController
            self.present(vc, animated: true)
        }
    }
    
    func preSetup() {
        settingTable.tableFooterView = UIView()
        settingTable.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        settingTable.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionInfo.text = appVersion
        darkModeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchDidchange(_:)), for: .valueChanged)
        automaticSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        automaticSwitch.addTarget(self, action: #selector(automaticSwitchDidChange(_:)), for: .valueChanged)
        
        backIcon = UIImage(named: "leftArrow")
        let tempImg = backIcon.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tempImg, for: .normal)
        
        nextIcon = UIImage(named: "next")
        let tempImg2 = nextIcon.withRenderingMode(.alwaysTemplate)
        nextBtn_1.setImage(tempImg2, for: .normal)
        nextBtn_2.setImage(tempImg2, for: .normal)
        nextBtn_3.setImage(tempImg2, for: .normal)
        nextBtn_4.setImage(tempImg2, for: .normal)
        nextBtn_5.setImage(tempImg2, for: .normal)
        nextBtn_6.setImage(tempImg2, for: .normal)
        
        /// Remove Ads
        nextBtn_1.addTarget(self, action: #selector(nextBtn1_Tapped), for: .touchUpInside)
        /// Category Setting
        nextBtn_2.addTarget(self, action: #selector(nextBtn2_Tapped), for: .touchUpInside)
        /// Clear all data
        nextBtn_3.addTarget(self, action: #selector(nextBtn3_Tapped), for: .touchUpInside)
    }
    
    /// Remove Ads
    @objc func nextBtn1_Tapped() {
        let vc1 = storyboard?.instantiateViewController(identifier: "removeAds") as! IAPController
        vc1.modalPresentationStyle = .overCurrentContext
        self.present(vc1, animated: true, completion: nil)
    }
    
    /// Category Setting
    @objc func nextBtn2_Tapped() {
        let vc2 = storyboard?.instantiateViewController(identifier: "categorySetting") as! CategorySettingCtrl
        self.navigationController?.pushViewController(vc2, animated: true)
    }
    
    @objc func nextBtn3_Tapped() {
        createAlert(alertTitle: NSLocalizedString("Clear All Data", comment: "Clear all data Alert - Title"), alertMessage: NSLocalizedString("All this app's data will be deleted permanently. \nDo you want to continue?", comment: ""))
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        navTitle.text = NSLocalizedString("Settings", comment: "")
        navTitle.alpha = 0.7
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        settingTable.backgroundColor = Theme.currentTheme.backgroundColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        versionInfo.textColor = Theme.currentTheme.accentColor
        backBtn.tintColor = Theme.currentTheme.accentColor
        nextBtn_1.tintColor = Theme.currentTheme.accentColor
        nextBtn_2.tintColor = Theme.currentTheme.accentColor
        nextBtn_3.tintColor = Theme.currentTheme.accentColor
        nextBtn_4.tintColor = Theme.currentTheme.accentColor
        nextBtn_5.tintColor = Theme.currentTheme.accentColor
        nextBtn_6.tintColor = Theme.currentTheme.accentColor
        darkModeSwitch.onTintColor = Theme.currentTheme.accentColor
        settingTable.reloadData()
    }
    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        header.backgroundColor = .clear
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: tableView.sectionHeaderHeight))
        
        switch section {
        case 0:
            headerText.text = NSLocalizedString("IN-APP PURCHASE", comment: "")
        case 1:
            headerText.text = NSLocalizedString("DISPLAY", comment: "")
        case 2:
            headerText.text = NSLocalizedString("DATA MANAGEMENT", comment: "")
        case 3:
            headerText.text = NSLocalizedString("LEARN MORE", comment: "")
        default:
            break
        }
        
        headerText.textColor = Theme.currentTheme.headerTitleColor
        headerText.font = FontSizeControl.currentFontSize.headerTextSize
        headerText.alpha = 0.68
        header.addSubview(headerText)
        header.addBottomBorder(0.5)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        footer.addTopBorder(0.6, view: tableView)
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Theme.currentTheme.lightCellColor
        cell.textLabel!.textColor = Theme.currentTheme.headerTitleColor
        cell.textLabel?.font = FontSizeControl.currentFontSize.cellTextSize
        
        cell.selectionStyle = .none
        tableView.separatorColor = Theme.currentTheme.separatorColor
        
        switch indexPath {
        case [0, 0]:
            cell.textLabel!.text = "Simply Workout Pro"
        case [1, 0]:
            cell.textLabel!.text = NSLocalizedString("Dark Mode", comment: "")
        case [1, 1]:
            cell.textLabel!.text = NSLocalizedString("Auto Mode", comment: "")
        case [1, 2]:
            cell.textLabel!.text = NSLocalizedString("Text Size", comment: "config screen title")
        case [2, 0]:
            cell.textLabel!.text = NSLocalizedString("Category Settings", comment: "config screen title")
        case [2, 1]:
            cell.textLabel!.text = NSLocalizedString("Clear all Data", comment: "config screen title")
        case [3, 0]:
            cell.textLabel!.text = NSLocalizedString("App Version", comment: "")
        case [3, 1]:
            cell.textLabel!.text = NSLocalizedString("Write a Review", comment: "")
        case [3, 2]:
            cell.textLabel!.text = NSLocalizedString("License", comment: "config screen title")
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case [0, 0]:
            nextBtn1_Tapped()
        case [1, 2]:
            let vc3 = storyboard?.instantiateViewController(identifier: "fontSizeCtrl") as! FontSizeController
            self.navigationController?.pushViewController(vc3, animated: true)
        case [2, 0]:
            nextBtn2_Tapped()
        case [2, 1]:
            /// remove all data
            nextBtn3_Tapped()
        case [3, 1]:
            print("d")
        case [3, 2]:
            /// license
            let vc4 = storyboard?.instantiateViewController(identifier: "licenseCtrl") as! License
            self.navigationController?.pushViewController(vc4, animated: true)
        default:
            break
        }
    }
    
    func removeAllData(_ entity: String) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for object in results {
                guard let objectData = object as? NSManagedObject else { continue }
                context.delete(objectData)
            }
            
            try context.save()
        }
        catch let err {
            print(err)
        }
    }
    
    func createAlert(alertTitle: String?, alertMessage: String?) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let addTask = UIAlertAction(title: NSLocalizedString("Clear", comment: "Clear all data Alert - Clear Button"), style: .default) { (_) in
            self.removeAllData("CategoryCD")
            self.removeAllData("EventDateCD")
            self.removeAllData("WorkoutDataCD")
            print("all data has been deleted.")
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Cancel_Clear Alert", comment: "Clear all data Alert - Cancel Button"), style: .cancel) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(addTask)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
}
