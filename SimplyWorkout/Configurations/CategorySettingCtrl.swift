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
        fetchAndUpdateData()
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
        categoryTable.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
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
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        vc.addCategoryDelegate = self
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
    func addCategoryData(activityName: String, ColorTag: String) {
        
        let categoryData = CategoryCD(context: context)
        categoryData.activityName_c = activityName
        categoryData.colorTag_c = ColorTag
        
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

extension CategorySettingCtrl: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategorySetViewCell
        
        cell.categoryData = categoryArray[indexPath.row]
        cell.backgroundColor = Theme.currentTheme.backgroundColor
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = categoryArray[indexPath.row]
            context.delete(cell)
            /// save the data
            do {
                try self.context.save()
            }
            catch {
            }
            fetchAndUpdateData()
        }
    }
}
