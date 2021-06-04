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
//            repeat_label.text = NSLocalizedString("Mon, Tue, Wed, Thu", comment: "Repeat Label")
            repeat_label.textColor = Theme.currentTheme.accentColor
        }
    }
}
