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
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        preSetup()
    }
    
    func preSetup() {
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = Theme.currentTheme.backgroundColor
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 28))
        header.backgroundColor = .clear
        let headerText = UILabel(frame: CGRect(x: 20, y: 0, width: 180, height: tableView.sectionHeaderHeight))
        headerText.text = "DISPLAY THEME"
        headerText.textColor = Theme.currentTheme.headerTitleColor
        headerText.font = UIFont.systemFont(ofSize: 12, weight: .regular)
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
        cell.backgroundColor = UIColor.applyColor(AssetsColor.notWhite)
        cell.tintColor = UIColor.applyColor(AssetsColor.paleBrown)
        
        
        let checkImgView = UIImageView()
        checkImgView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        checkImgView.tintColor = UIColor.applyColor(AssetsColor.paleBrown)
        cell.accessoryView = checkImgView
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            }
        }
        print(indexPath)
    }
}
