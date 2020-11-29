//
//  LightTheme.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 13/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class LightTheme: ThemeProtocol {
 
    var textColor: UIColor = UIColor.black
    
    var accentColor: UIColor = UIColor.applyColor(AssetsColor.paleBrown)!
    
    var textColorInDarkBg: UIColor = UIColor.white
    
    var lightCellColor: UIColor = UIColor.applyColor(AssetsColor.notWhite)!
    
    var backgroundColor: UIColor = UIColor.applyColor(AssetsColor.cream)!
    
    var cancelBtnColor: UIColor = UIColor.applyColor(AssetsColor.softGrey)!
    
    var separatorColor: UIColor = UIColor.separator
    
    var tagCellColor: UIColor = UIColor.applyColor(AssetsColor.notWhite)!
    
    var segmentColor: UIColor = UIColor.applyColor(AssetsColor.notWhite)!
    
    var opacityText: UIColor = UIColor.systemGray2
    
    var addIconTextColor: UIColor = UIColor.darkGray
    
    var pickerBorderColor: UIColor = UIColor.systemGray5
    
    /// ProgressBar settings
    var baseProgressColor: UIColor = UIColor.applyColor(AssetsColor.baseProgress)!
    var startColorOfProgress: UIColor = UIColor.applyColor(AssetsColor.paleBrown)!
    
    /// Calendar settings
    var headerTitleColor: UIColor = UIColor.black
    
    var weekdayTextColor: UIColor = UIColor.black
    
    var dateTextColor: UIColor = UIColor.black
    
    var selectionColor: UIColor = UIColor.applyColor(AssetsColor.paleBrown)!
    
    var titleTodayColor: UIColor = UIColor.applyColor(AssetsColor.vivacious)!

}
