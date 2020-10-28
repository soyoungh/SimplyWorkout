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
    
    var categoryData: CategoryCD! {
        didSet {
            activityName.text = categoryData.activityName_c
            activityName.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            activityName.textColor = Theme.currentTheme.textColor
            colorTag.layer.cornerRadius = 10
            colorTag.backgroundColor = UIColor(named: categoryData.colorTag_c!)
        }
    }
}
