//
//  CategorySettingCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/24.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class CategorySettingCtrl: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var categoryTable: UITableView!
    
    var backIcon: UIImage!
    var categoryAddPopupCtrl = CategoryAddPopupCtrl()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        presetup()
        setupNavBar()
        applyTheme()
    }
    
    func presetup() {
        backIcon = UIImage(named: "leftArrow")
        let tempImg = backIcon.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(tempImg, for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnTapped), for: .touchUpInside)
        categoryTable.tableFooterView = UIView()
        plusBtn.addTarget(self, action: #selector(plusBtnDidTapped), for: .touchUpInside)
        categoryTable.dataSource = self
    }
    
    @objc func backBtnTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "settingPage") as! ConfigurationsController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func plusBtnDidTapped() {
        let vc = storyboard?.instantiateViewController(identifier: "categoryAddPopup") as! CategoryAddPopupCtrl
        self.navigationController?.present(vc, animated: true)
        self.navigationController?.modalPresentationStyle = .currentContext
    }
    
    func applyTheme() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        backBtn.tintColor = Theme.currentTheme.accentColor
        plusBtn.tintColor = Theme.currentTheme.accentColor
        navTitle.textColor = Theme.currentTheme.headerTitleColor
        categoryTable.backgroundColor = Theme.currentTheme.backgroundColor
    }
    
    func setupNavBar() {
        navTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        navTitle.text = "Category Settings"
        navTitle.alpha = 0.7
    }
    
}

extension CategorySettingCtrl: AddNewCategories {
    func addNewCategoryData(activityName: String, colorTag: String) {
       print("add a new category.")
    }
}

extension CategorySettingCtrl: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = UITableViewCell(style: .default, reuseIdentifier: nil)
        
        return tableCell
    }
    
    
}
