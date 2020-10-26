//
//  ConfigurationsController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/09/22.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import Foundation
import UIKit

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
    
    var backIcon: UIImage!
    var nextIcon: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        // Retrieve state
        let darkModeOnoff = UserDefaults.standard.bool(forKey: "DarkTheme")
        darkModeSwitch.setOn(darkModeOnoff, animated: false)
        
        let autoModeOnoff = UserDefaults.standard.bool(forKey: "AutoMode")
        automaticSwitch.setOn(autoModeOnoff, animated: false)
    }
    
    override func viewDidLoad() {
        
        preSetup()
        setupNavBar()
        applyTheme()
    }
    
    @objc func automaticSwitchDidChange(_ sender: UISwitch) {
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
    
    @objc func darkModeSwitchDidchange(_ sender: UISwitch) {
        Theme.currentTheme = sender.isOn ? DarkTheme() : LightTheme()
        UserDefaults.standard.set(sender.isOn, forKey: "DarkTheme")
        applyTheme()
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
        
        nextBtn_2.addTarget(self, action: #selector(nextBtn2_Tapped), for: .touchUpInside)
    }
    
    @objc func nextBtn2_Tapped() {
        let vc = storyboard?.instantiateViewController(identifier: "categorySetting") as! CategorySettingCtrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
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
        darkModeSwitch.onTintColor = Theme.currentTheme.accentColor
        settingTable.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        header.backgroundColor = .clear
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: tableView.sectionHeaderHeight))
        
        switch section {
        case 0:
            headerText.text = "SIMPLY WORKOUT PRO"
        case 1:
            headerText.text = "DISPLAY THEME"
        case 2:
            headerText.text = "DATA MANAGEMENT"
        case 3:
            headerText.text = "LEARN MORE"
        default:
            break
        }
        
        headerText.textColor = Theme.currentTheme.headerTitleColor
        headerText.font = UIFont.systemFont(ofSize: 12, weight: .light)
        headerText.alpha = 0.68
        header.addSubview(headerText)
        header.addBottomBorder(0.5)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        footer.addTopBorder(0.5)
        return footer
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = Theme.currentTheme.lightCellColor
        cell.textLabel!.textColor = Theme.currentTheme.headerTitleColor
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        cell.selectionStyle = .none
        tableView.separatorColor = Theme.currentTheme.separatorColor
        
        switch indexPath {
        case [0, 0]:
            cell.textLabel!.text = "Remove all Ads"
        case [1, 0]:
            cell.textLabel!.text = "Dark Mode"
        case [1, 1]:
            cell.textLabel!.text = "Automatic"
        case [2, 0]:
            cell.textLabel!.text = "Category Settings"
        case [2, 1]:
            cell.textLabel!.text = "Clear all Data"
        case [3, 0]:
            cell.textLabel!.text = "App Version"
        case [3, 1]:
            cell.textLabel!.text = "Write a Review"
        case [3, 2]:
            cell.textLabel!.text = "License"
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


