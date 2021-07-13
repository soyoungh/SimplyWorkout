//
//  CategorySetViewCell.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/26.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class CategorySetViewCell: UITableViewCell {
    
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var alarm_closure_Icon: UIButton!
    @IBOutlet weak var alarm_LocalTitle: UILabel!
    @IBOutlet weak var repeat_label: UILabel!
    
    /// day of the week
    var cellmon = NSLocalizedString("cell_mon", comment: "cell_mon")
    var celltue = NSLocalizedString("cell_tue", comment: "cell_tue")
    var cellwed = NSLocalizedString("cell_wed", comment: "cell_wed")
    var cellthu = NSLocalizedString("cell_thu", comment: "cell_thu")
    var cellfri = NSLocalizedString("cell_fri", comment: "cell_fri")
    var cellsat = NSLocalizedString("cell_sat", comment: "cell_sat")
    var cellsun = NSLocalizedString("cell_sun", comment: "cell_sun")
    
    
    var nextIcon: UIImage!
    var categoryData: CategoryCD! {
        didSet {
            activityName.text = categoryData.activityName_c
            activityName.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            activityName.textColor = Theme.currentTheme.textColor
            colorTag.layer.cornerRadius = colorTag.layer.frame.width / 2
            colorTag.backgroundColor = UIColor(named: categoryData.colorTag_c!)
            
            nextIcon = UIImage(systemName: "circle.fill")
            let closureImg = nextIcon.withRenderingMode(.alwaysTemplate)
            alarm_closure_Icon.setImage(closureImg, for: .normal)
            alarm_closure_Icon.tintColor = .systemGreen
            alarm_LocalTitle.text = NSLocalizedString("Alarm on", comment: "Alarm Setting")
            alarm_LocalTitle.textColor = Theme.currentTheme.accentColor
            
            /// nil check
            if categoryData.frequency != nil {
                if [cellmon, celltue, cellwed, cellthu, cellfri
                ].allSatisfy(categoryData.frequency!.contains) {
                    repeat_label.text = "Weekdays"
                }
                else if [cellsat, cellsun].allSatisfy(categoryData.frequency!.contains) {
                    repeat_label.text = "Weekends"
                }
                else {
                    repeat_label.text = categoryData.frequency
                }
            }
            else {
                repeat_label.text = categoryData.frequency
            }
            
            repeat_label.textColor = Theme.currentTheme.accentColor
        }
    }
}
