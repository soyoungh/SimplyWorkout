//
//  CategoryAddPopupCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/25.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit
import CoreData

protocol AddCategory {
    func addCategoryData (activityName: String, colorTag: String)
}

class CategoryAddPopupCtrl: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var activityTitle: UILabel!
    @IBOutlet weak var activityField: UITextField!
    @IBOutlet weak var colorTagTitle: UILabel!
    @IBOutlet weak var colorTagView: UICollectionView!
    @IBOutlet weak var saveBtn: UIButton!
    
    var colorTagCtrl = CategoryColorCtrl()
    var addCategoryDelegate: AddCategory?
    
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
        activityTitle.text = NSLocalizedString("cate_TYPE OF ACTIVITY", comment: "categoryPage_activityTitle")
        activityField.backgroundColor = Theme.currentTheme.tagCellColor
        activityField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Add a type of exercise here.", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: Theme.currentTheme.opacityText])
        activityField.layer.masksToBounds = true
        activityField.layer.cornerRadius = 5
        activityField.layer.borderWidth = 1
        activityField.layer.borderColor = Theme.currentTheme.separatorColor.cgColor
        activityField.textColor = Theme.currentTheme.textColor
        
        colorTagTitle.detailPageTitleSet()
        colorTagTitle.text = NSLocalizedString("cate_COLOR TAG", comment: "categoryPage_colorTagTitle")
        colorTagView.customView()
        
        saveBtn.setTitleColor(Theme.currentTheme.accentColor, for: .normal)
        saveBtn.addTarget(self, action: #selector(saveBtnDidTapped), for: .touchUpInside)
        saveBtn.setTitle(NSLocalizedString("cate_Save", comment: "categoryPage_saveBtn"), for: .normal)
    }
    
    @objc func dismissOnTapOutside() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func saveBtnDidTapped() {
        if activityField.text != "" && colorTagCtrl.selectedColor != nil {
            
            let request = CategoryCD.createFetchRequest()
            
            do {
                let dataResults = try (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(request)
                let actFilter = dataResults.filter { $0.activityName_c! == activityField.text || $0.colorTag_c! == colorTagCtrl.selectedColor
                }

                if actFilter.isEmpty == false {
                    createAlertPopup(alertTitle: NSLocalizedString("Error", comment: "category pop up alert - Title"), alertMessage: NSLocalizedString("alert message", comment: "category pop up alert - Message"))
                }
                else {
                    addNewCategory()
                }
            }
            catch {
                
            }
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func addNewCategory() {
            guard let del = addCategoryDelegate else {
                return
            }
            del.addCategoryData(activityName: activityField.text!, colorTag: colorTagCtrl.selectedColor!)
            dismiss(animated: true, completion: nil)
    }
    
    func createAlertPopup(alertTitle: String, alertMessage: String){
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { action in
//            print("tapped dismiss")
        }))
        present(alert, animated: true)
    }
}
