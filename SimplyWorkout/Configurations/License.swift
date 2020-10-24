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
    
    var backIcon: UIImage!
    var disclosureIcon: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        presetup()
        applyTheme()
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
    
    @objc func didTapGoogle() {
        let url = URL(string: "https://www.flaticon.com/")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        
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
            headerText.text = "OPEN SOURCE"
        case 1:
            headerText.text = "ICON IMAGES"
        default:
            break
        }
        
        headerText.textColor = Theme.currentTheme.headerTitleColor
        headerText.font = UIFont.systemFont(ofSize: 12, weight: .light)
        headerText.alpha = 0.68
        header.addSubview(headerText)
        
        return header
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
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
            cell.textLabel!.text = "FScalendar"
        case [1, 0]:
            cell.textLabel!.text = "Flaticon"
        default:
            break
        }
    }
}
