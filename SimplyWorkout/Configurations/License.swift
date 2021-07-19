//
//  License.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/23.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class License: UITableViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var disclosureBtn: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    
    var backIcon: UIImage!
    var disclosureIcon: UIImage!
    
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
    }
    
    override func viewDidLoad() {
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
        
        disclosureIcon = UIImage(named: "next")
        let tempImg2 = disclosureIcon.withRenderingMode(.alwaysTemplate)
        disclosureBtn.setImage(tempImg2, for: .normal)
        disclosureBtn.addTarget(self, action: #selector(didTapGoogle), for: .touchUpInside)
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        navTitle.text = NSLocalizedString("lp_License", comment: "enter the license page")
        navTitle.alpha = 0.7
    }
    
    @objc func didTapGoogle() {
        let url = URL(string: "https://www.flaticon.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        backBtn.tintColor = Theme.currentTheme.accentColor
        disclosureBtn.tintColor = Theme.currentTheme.accentColor
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        header.backgroundColor = .clear
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: tableView.sectionHeaderHeight))
        
        switch section {
        case 0:
            headerText.text = NSLocalizedString("OPEN SOURCE", comment: "")
        case 1:
            headerText.text = NSLocalizedString("ICON IMAGES", comment: "")
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
            cell.textLabel!.text = "FScalendar"
        case [0, 1]:
            cell.textLabel!.text = "Charts"
        case [1, 0]:
            cell.textLabel!.text = "Flaticon"
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath == [1, 0] {
            didTapGoogle()
        }
    }
}
