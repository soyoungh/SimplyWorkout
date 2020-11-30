//
//  DarkTheme.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/09/29.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class DarkTheme: ThemeProtocol {
    
    var textColor: UIColor = UIColor.white
    
    var accentColor: UIColor = UIColor.applyColor(AssetsColor.turquoise)!
    
    var textColorInDarkBg: UIColor = UIColor.white
    
    var lightCellColor: UIColor = UIColor.applyColor(AssetsColor.c_darkGrey)!
    
    var backgroundColor: UIColor = UIColor.applyColor(AssetsColor.adobeDarkGrey)!
    
    var cancelBtnColor: UIColor = UIColor.applyColor(AssetsColor.c_darkGrey)!
    
    var separatorColor: UIColor = UIColor.applyColor(AssetsColor.c2_darkGrey)!
    
    var tagCellColor: UIColor = UIColor.applyColor(AssetsColor.adobeDarkGrey)!
    
    var segmentColor: UIColor = UIColor.applyColor(AssetsColor.turquoise)!
    
    var opacityText: UIColor = UIColor.darkGray
    
    var addIconTextColor: UIColor = UIColor.systemGray
    
    var pickerBorderColor: UIColor = UIColor.applyColor(AssetsColor.c2_darkGrey)!
    
    /// ProgressBar settings
    var baseProgressColor: UIColor = UIColor.applyColor(AssetsColor.c_darkGrey)!
    
    var startColorOfProgress: UIColor = UIColor.applyColor(AssetsColor.summerStorm)!
    
    /// Calendar settings
    var headerTitleColor: UIColor = UIColor.applyColor(AssetsColor.notWhite)!
    
    var weekdayTextColor: UIColor = UIColor.applyColor(AssetsColor.notWhite)!
    
    var dateTextColor: UIColor = UIColor.white
    
    var selectionColor: UIColor = UIColor.applyColor(AssetsColor.turquoise)!
    
    var titleTodayColor: UIColor = UIColor.applyColor(AssetsColor.oriole)!
    
}
