//
//  WorkoutTableViewCell.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 29/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    @IBOutlet weak var colorTag: UIView!
    @IBOutlet weak var activityName: UILabel!
    @IBOutlet weak var activityDetail: UILabel!
    @IBOutlet weak var effortProgress: ProgressBar!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var workoutData : WorkoutDataCD! {
        didSet {
            activityName.text = workoutData.activityName
            activityName.font = FontSizeControl.currentFontSize.bodyTextSize
            activityName.textColor = Theme.currentTheme.textColor

            activityDetail.text = workoutData.detail
            activityDetail.font = FontSizeControl.currentFontSize.subTextSize
            activityDetail.numberOfLines = 0
            activityDetail.sizeToFit()
            activityDetail.frame = CGRect(x: 0, y: 0, width: 288, height: CGFloat.greatestFiniteMagnitude)
            activityDetail.textColor = Theme.currentTheme.textColor
            
            intensityLabel.text = workoutData.effortType
            intensityLabel.font = FontSizeControl.currentFontSize.smallestTextSize
            intensityLabel.textColor = Theme.currentTheme.textColor
            
            effortProgress.drawProgress(selectedType: intensityLabel.text!)
            effortProgress.backgroundColor = UIColor.clear
            
            durationLabel.text = workoutData.duration
            durationLabel.font = FontSizeControl.currentFontSize.extraTextSize
            durationLabel.textColor = Theme.currentTheme.textColor
            
            colorTag.layer.cornerRadius = 5
            colorTag.backgroundColor = UIColor(named: workoutData.colorTag!)
            
            locationLabel.layer.borderColor = Theme.currentTheme.accentColor.cgColor
            locationLabel.text = workoutData.location
            locationLabel.layer.borderWidth = 1.0
            locationLabel.layer.cornerRadius = 5.0
            locationLabel.layer.masksToBounds = true
            locationLabel.textColor = Theme.currentTheme.accentColor
            locationLabel.font = FontSizeControl.currentFontSize.extraTextSize
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateLabel.text = dateFormatter.string(from: workoutData.created!)
            dateLabel.font = FontSizeControl.currentFontSize.extraTextSize
            dateLabel.textColor = Theme.currentTheme.accentColor
            
        }
    }
}
