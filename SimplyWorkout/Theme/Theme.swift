//
//  Theme.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 13/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit
import FSCalendar

class Theme {
    
    static var currentTheme: ThemeProtocol = LightTheme()
    
    static var calendar =  FSCalendar() {
        
        didSet {
            let prefixSet = calendar.appearance
            let currentSet = currentTheme
            
            prefixSet.headerTitleColor = currentSet.headerTitleColor
            prefixSet.weekdayTextColor = currentSet.weekdayTextColor
            prefixSet.selectionColor = currentSet.selectionColor
            prefixSet.titleDefaultColor = currentSet.dateTextColor
            
            // Common Calendar theme settings
            prefixSet.headerDateFormat = "MMMM YYYY"
            prefixSet.headerMinimumDissolvedAlpha = 0.0
            prefixSet.headerTitleFont = FontSizeControl.currentFontSize.c_headerTextSize
            prefixSet.weekdayFont = FontSizeControl.currentFontSize.c_weekdayTextSize
            prefixSet.titleFont = FontSizeControl.currentFontSize.c_weekdayTextSize
            prefixSet.todayColor = UIColor.clear
            prefixSet.borderRadius = 1.0
              
        }
    }
 
}
