//
//  Customization.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 13/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

extension UIButton {
    
    func customPlusButton() {
        backgroundColor = UIColor.applyColor(AssetsColor.paleBrown)
        tintColor = UIColor.white
        layer.cornerRadius = frame.width / 2
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 1, height: 2)
    }
    
    func roundedCornerBtn() {
        layer.cornerRadius = 5
    }
    
    func outlinedBtn() {
        layer.backgroundColor = UIColor.clear.cgColor
        layer.borderWidth = 2
        layer.borderColor = UIColor.applyColor(AssetsColor.turquoise)?.cgColor
        tintColor = UIColor.applyColor(AssetsColor.turquoise)
    }

}

extension UICollectionView {
    
    func customView() {
        
       layer.backgroundColor = UIColor.applyColor(AssetsColor.notWhite)?.cgColor
     
//        layer.shadowColor = UIColor.darkGray.cgColor
//        layer.shadowRadius = 5
//        layer.shadowOpacity = 0.8
//        layer.shadowOffset = CGSize.init(width: 5, height: 5)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.cornerRadius = 5
    }
}

extension UIView {

    func addBorder(_ width: CGFloat) {
       let border = CALayer()
        border.backgroundColor = UIColor.separator.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        //border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        border.opacity = 0.8
        self.layer.addSublayer(border)
    }
}

extension UITextView {
    
    func customTextView() {
        layer.masksToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
}
