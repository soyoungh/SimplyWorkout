//
//  ThemeProtocol.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 13/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    
    /// General settings
    var textColor: UIColor { get }
    var accentColor: UIColor { get }
    var textColorInDarkBg: UIColor { get }
    var lightCellColor: UIColor { get }
    var backgroundColor: UIColor { get }
    var cancelBtnColor: UIColor { get }
    var separatorColor: UIColor { get }
    var tagCellColor: UIColor { get }
    var segmentColor: UIColor { get }
    var opacityText: UIColor { get }
    var addIconTextColor: UIColor { get }
    var pickerBorderColor: UIColor { get }
    var dayOfTheWeekBtnColor: UIColor { get }
    
    /// ProgressBar settings
    var baseProgressColor: UIColor { get }
    var startColorOfProgress: UIColor { get }
    
    /// Calendar settings
    var headerTitleColor: UIColor { get }
    var weekdayTextColor: UIColor { get }
    var dateTextColor: UIColor { get }
    var selectionColor: UIColor { get }
    var titleTodayColor: UIColor { get }
}


