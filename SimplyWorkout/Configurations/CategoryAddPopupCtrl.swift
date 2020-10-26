//
//  CategoryAddPopupCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/25.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class CategoryAddPopupCtrl: UIViewController {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityField: UITextField!
    @IBOutlet weak var colorTagTitle: UILabel!
    @IBOutlet weak var colorTagView: UICollectionView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var colorTagCtrl = ColorTagCtrl()
    var addNewCategories: AddNewCategories?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colorTagView.delegate = colorTagCtrl
        colorTagView.dataSource = colorTagCtrl
        presetup()
    }
    
    func presetup() {
        popupView.backgroundColor = Theme.currentTheme.backgroundColor
        popupView.layer.cornerRadius = 10
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(dismissOnTapOutside))
        backgroundView.addGestureRecognizer(dismissTap)
        
        activityTitle.detailPageTitleSet()
        activityField.backgroundColor = Theme.currentTheme.tagCellColor
        activityField.attributedPlaceholder = NSAttributedString(string: "Add an activity title here.", attributes: [NSAttributedString.Key.foregroundColor: Theme.currentTheme.opacityText])
        activityField.layer.masksToBounds = true
        activityField.layer.cornerRadius = 5
        activityField.layer.borderWidth = 1
        activityField.layer.borderColor = Theme.currentTheme.separatorColor.cgColor
        activityField.textColor = Theme.currentTheme.textColor
        
        colorTagTitle.detailPageTitleSet()
        colorTagView.customView()
        
        saveBtn.tintColor = Theme.currentTheme.accentColor
        saveBtn.addTarget(self, action: #selector(saveBtnDidTapped), for: .touchUpInside)
    }
    
    @objc func dismissOnTapOutside() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnDidTapped() {
        addNewCategory()
    }
    
    func addNewCategory() {
        if activityField.text != "" && colorTagCtrl.selectedColor != "" {
            guard let del = addNewCategories else {
                return
            }
            del.addNewCategoryData(activityName: activityField.text!, colorTag: colorTagCtrl.selectedColor!)
            
            dismiss(animated: true, completion: nil)
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
}

protocol AddNewCategories {
    func addNewCategoryData (activityName: String, colorTag: String)
}
