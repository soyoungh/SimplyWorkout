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
    
    var workoutData : WorkoutData! {
        didSet {
            activityName.text = workoutData.activityName
            //activityName.textColor = UIColor(named: workoutData.colorTag)
            
            activityDetail.text = workoutData.detail
            intensityLabel.text = workoutData.effortType
            durationLabel.text = workoutData.duration
            effortProgress.drawProgress(selectedType: intensityLabel.text!)
            
            colorTag.layer.cornerRadius = 5
            colorTag.backgroundColor = UIColor(named: workoutData.colorTag)
            
            locationLabel.layer.borderColor = UIColor.applyColor(AssetsColor.paleBrown)?.cgColor
            locationLabel.text = " Outside "
            locationLabel.layer.borderWidth = 1.0
            locationLabel.layer.cornerRadius = 5.0
            locationLabel.layer.masksToBounds = true
            locationLabel.textColor = UIColor.applyColor(AssetsColor.paleBrown)
            
            dateLabel.text = DateFormatter().string(from: workoutData.date!)
            dateLabel.textColor = UIColor.applyColor(AssetsColor.paleBrown)
            
        }
    }
}
