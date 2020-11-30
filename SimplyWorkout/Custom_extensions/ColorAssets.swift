//
//  ColorAssets.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 12/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

enum AssetsColor: String {
    case cream
    case adobeDarkGrey
    case paleBrown
    case raspberries = "raspberries"
    case vivacious
    case sulphurSpring = "sulphurSpring"
    case livingCoral
    case bamboo
    case barrierReef = "barrierReef"
    case bodacious = "bodacious"
    case chiveBlossom
    case citrusSol = "citrusSol"
    case deepLake
    case floraFirma = "floraFirma"
    case ibizaBlue = "ibizaBlue"
    case oriole = "oriole"
    case pinkLemonade = "pinkLemonade"
    case summerStorm = "summerStorm"
    case turquoise = "turquoise"
    case butterRum = "butterRum"
    case notWhite
    case softGrey
    case baseProgress
    case c_darkGrey
    case c2_darkGrey
}

extension UIColor {
    
    static func applyColor(_ name: AssetsColor) -> UIColor? {
        
        switch name {
        case .cream:
            return UIColor(named: "cream")
        case .adobeDarkGrey:
            return UIColor(named: "adobeDarkGrey")
        case .paleBrown:
            return UIColor(named: "paleBrown")
        case .raspberries:
            return UIColor(named: "raspberries")
        case .vivacious:
            return UIColor(named: "vivacious")
        case .sulphurSpring:
            return UIColor(named: "sulphurSpring")
        case .livingCoral:
            return UIColor(named: "livingCoral")
        case .bamboo:
            return UIColor(named: "bamboo")
        case .barrierReef:
            return UIColor(named: "barrierReef")
        case .bodacious:
            return UIColor(named: "bodacious")
        case .butterRum:
            return UIColor(named: "butterRum")
        case .chiveBlossom:
            return UIColor(named: "chiveBlossom")
        case .citrusSol:
            return UIColor(named: "citrusSol")
        case .deepLake:
            return UIColor(named: "deepLake")
        case .floraFirma:
            return UIColor(named: "floraFirma")
        case .ibizaBlue:
            return UIColor(named: "ibizaBlue")
        case .oriole:
            return UIColor(named: "oriole")
        case .pinkLemonade:
            return UIColor(named: "pinkLemonade")
        case .summerStorm:
            return UIColor(named: "summerStorm")
        case .turquoise:
            return UIColor(named: "turquoise")
        case .notWhite:
            return UIColor(named: "notWhite")
        case .softGrey:
            return UIColor(named: "softGrey")
        case .baseProgress:
            return UIColor(named: "baseProgress")
        case .c_darkGrey:
            return UIColor(named: "c_darkGrey")
        case .c2_darkGrey:
            return UIColor(named: "c2_darkGrey")
        }
        
    }
}
