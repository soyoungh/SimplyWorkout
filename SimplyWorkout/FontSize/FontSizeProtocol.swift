//
//  FontSizeProtocol.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/11/02.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

protocol FontSizeProtocol {
    
    /// activityName  text - 16 , regular
    var bodyTextSize: UIFont { get }

    /// activity Detail text - 14, light
    var subTextSize: UIFont { get }

    /// duration, location, dateLabel -13, regular
    var extraTextSize: UIFont { get }

    /// intensityLabel -12, regular
    var smallestTextSize: UIFont { get }
  
    /// cancel btn, done btn - 15, light
    var btnTextSize: UIFont { get }

    /// pickerView Label (duration, location) , Configuration Nav bar font -  17, regular
    var pickerTextSize: UIFont { get }

    /// Configuration header text - 12, light
    var headerTextSize: UIFont { get }

    /// configuration cell text - 15, regular
    var cellTextSize: UIFont { get }

    /// Calendar - header title text
    var c_headerTextSize: UIFont { get }
    
    /// Calendar - weekday text, date text
    var c_weekdayTextSize: UIFont { get }
    
    /// Add Page - activity and detail field
    var add_fieldTextSize: UIFont { get }
    
    /// Report Page
    var reportMonthLabel: UIFont { get }
    
    /// AddAlarm Page - frequency , Configuration Page- version info
    var versionInfoLabel: UIFont { get }
}
