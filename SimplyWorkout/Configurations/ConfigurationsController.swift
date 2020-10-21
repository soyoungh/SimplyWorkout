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
    var backIcon: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        let darkModeOnoff = UserDefaults.standard.bool(forKey: "DarkTheme")
        darkModeSwitch.setOn(darkModeOnoff, animated: false)
    }
    
    override func viewDidLoad() {
        preSetup()
        setupNavBar()
        applyTheme()
    }
    
    @objc func automaticSwitchDidChange(_ sender: UISwitch) {
        //        let userCtrlSwitch = UserDefaults.standard
        //        userCtrlSwitch.set(sender.isOn, forKey: "switchOnOff")
        //        if sender.isOn {
        //
        //        }
        //        else {
        //
        //        }
    }
    
    @objc func darkModeSwitchDidchange(_ sender: UISwitch) {
        Theme.currentTheme = sender.isOn ? DarkTheme() : LightTheme()
        UserDefaults.standard.set(sender.isOn, forKey: "DarkTheme")
        applyTheme()
    }
  
    func preSetup() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.sizeToFit()
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        versionInfo.text = appVersion
        darkModeSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        darkModeSwitch.addTarget(self, action: #selector(darkModeSwitchDidchange), for: .valueChanged)
        automaticSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        automaticSwitch.addTarget(self, action: #selector(automaticSwitchDidChange(_:)), for: .valueChanged)
        
        backIcon = UIImage(named: "leftArrow")
        let tempImg = backIcon.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tempImg, for: .normal)
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        navTitle.alpha = 0.7
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        versionInfo.textColor = Theme.currentTheme.accentColor
        backBtn.tintColor = Theme.currentTheme.accentColor
        tableView.reloadData()
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
            cell.accessoryType = .disclosureIndicator
        case [1, 0]:
            cell.textLabel!.text = "Dark Mode"
            cell.accessoryType = .none
        case [1, 1]:
            cell.textLabel!.text = "Automatic"
            cell.accessoryType = .none
        case [2, 0]:
            cell.textLabel!.text = "Category Settings"
            cell.accessoryType = .disclosureIndicator
        case [2, 1]:
            cell.textLabel!.text = "Clear all Data"
            cell.accessoryType = .disclosureIndicator
        case [3, 0]:
            cell.textLabel!.text = "App Version"
            cell.accessoryType = .none
        case [3, 1]:
            cell.textLabel!.text = "Write a Review"
            cell.accessoryType = .disclosureIndicator
        case [3, 2]:
            cell.textLabel!.text = "License"
            cell.accessoryType = .disclosureIndicator
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}


