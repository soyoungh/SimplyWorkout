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
            //activityName.textColor = UIColor(named: workoutData.colorTag)
            
            activityDetail.text = workoutData.detail
            activityDetail.numberOfLines = 0
            activityDetail.sizeToFit()
            activityDetail.frame = CGRect(x: 0, y: 0, width: 288, height: CGFloat.greatestFiniteMagnitude)
            
            intensityLabel.text = workoutData.effortType
            durationLabel.text = workoutData.duration
            effortProgress.drawProgress(selectedType: intensityLabel.text!)
            
            colorTag.layer.cornerRadius = 5
            colorTag.backgroundColor = UIColor(named: workoutData.colorTag!)
            
            locationLabel.layer.borderColor = UIColor.applyColor(AssetsColor.paleBrown)?.cgColor
            locationLabel.text = workoutData.location
            locationLabel.layer.borderWidth = 1.0
            locationLabel.layer.cornerRadius = 5.0
            locationLabel.layer.masksToBounds = true
            locationLabel.textColor = UIColor.applyColor(AssetsColor.paleBrown)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateLabel.text = dateFormatter.string(from: workoutData.created!)
            dateLabel.textColor = UIColor.applyColor(AssetsColor.paleBrown)
            
        }
    }
}
