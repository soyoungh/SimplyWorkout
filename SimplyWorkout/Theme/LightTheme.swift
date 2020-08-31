//
//  LightTheme.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 13/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class LightTheme: ThemeProtocol {
    
    var textColor: UIColor = UIColor.darkGray
    
    var backgroundColor: UIColor = UIColor.applyColor(AssetsColor.cream)!
    
    var headerTitleColor: UIColor = UIColor.darkGray
    
    var weekdayTextColor: UIColor = UIColor.darkGray
    
    var selectionColor: UIColor = UIColor.applyColor(AssetsColor.paleBrown)!    
}
