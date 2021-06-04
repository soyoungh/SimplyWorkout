//
//  X2FontSize.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/11/06.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class X2FontSize: FontSizeProtocol {
    
    /// activityName  text - 16 , regular
     var bodyTextSize: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)
     
     /// activity Detail text - 14, light
     var subTextSize: UIFont = UIFont.systemFont(ofSize: 15, weight: .light)
     
     /// duration, location, dateLabel -13, regular
     var extraTextSize: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)
     
     /// intensityLabel -12, regular
     var smallestTextSize: UIFont = UIFont.systemFont(ofSize: 13, weight: .regular)

     /// cancel btn, done btn - 15, light
     var btnTextSize: UIFont = UIFont.systemFont(ofSize: 16, weight: .light)

     /// pickerView Label (duration, location) , Configuration Nav bar font -  17, regular
     var pickerTextSize: UIFont = UIFont.systemFont(ofSize: 17, weight: .regular)

     /// Configuration header text - 12, light
     var headerTextSize: UIFont = UIFont.systemFont(ofSize: 13, weight: .light)

     /// configuration cell text - 15, regular
     var cellTextSize: UIFont = UIFont.systemFont(ofSize: 16, weight: .regular)
    
    /// Calendar - header title text
    var c_headerTextSize: UIFont = UIFont.systemFont(ofSize: 16, weight: .light)
    
    /// Calendar - weekday text, date text
    var c_weekdayTextSize: UIFont = UIFont.systemFont(ofSize: 14, weight: .light)
    
    /// Add Page - activity and detail field
    var add_fieldTextSize: UIFont = UIFont.systemFont(ofSize: 14, weight: .regular)

    /// Report Page
    var reportMonthLabel: UIFont = UIFont.systemFont(ofSize: 16, weight: .medium)
    
    /// AddAlarm Page - frequency , Configuration Page- version info
    var versionInfoLabel: UIFont = UIFont.systemFont(ofSize: 16, weight: .light)
}

