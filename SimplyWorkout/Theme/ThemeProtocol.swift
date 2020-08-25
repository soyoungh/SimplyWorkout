//
//  ThemeProtocol.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 13/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

protocol ThemeProtocol {
    
    // General settings
    var textColor: UIColor { get }
    var backgroundColor: UIColor { get }
    
    // Calendar settings
    var headerTitleColor: UIColor { get }
    var weekdayTextColor: UIColor { get }
    var selectionColor: UIColor { get }
  
}


