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
        backgroundColor = Theme.currentTheme.accentColor
        tintColor = UIColor.white
        layer.cornerRadius = layer.frame.width / 2
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
        
        layer.backgroundColor = Theme.currentTheme.tagCellColor.cgColor
        
        //        layer.shadowColor = UIColor.darkGray.cgColor
        //        layer.shadowRadius = 5
        //        layer.shadowOpacity = 0.8
        //        layer.shadowOffset = CGSize.init(width: 5, height: 5)
        
        layer.borderWidth = 1.0
        layer.borderColor = Theme.currentTheme.separatorColor.cgColor
        layer.cornerRadius = 5
    }
}

extension UIView {
    
    func addTopBorder(_ width: CGFloat, view: UIView) {
        let border = CALayer()
        border.backgroundColor = Theme.currentTheme.separatorColor.cgColor
        border.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: width)
        //border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        //        border.opacity = 0.8
        self.layer.addSublayer(border)
        self.setNeedsDisplay()
    }
    
    func addBottomBorder(_ width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = Theme.currentTheme.separatorColor.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        //     border.opacity = 0.8
        self.layer.addSublayer(border)
        self.setNeedsDisplay()
    }
    
    func addTopPickerBorder(_ width: CGFloat) {
           let border = CALayer()
           border.backgroundColor = Theme.currentTheme.pickerBorderColor.cgColor
           border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
           //border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
           //        border.opacity = 0.8
           self.layer.addSublayer(border)
           self.setNeedsDisplay()
       }
       
       func addBottomPickerBorder(_ width: CGFloat) {
           let border = CALayer()
           border.backgroundColor = Theme.currentTheme.pickerBorderColor.cgColor
           border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
           //     border.opacity = 0.8
           self.layer.addSublayer(border)
           self.setNeedsDisplay()
       }
}

extension UITextView {
    
    func customTextView() {
        layer.masksToBounds = true
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = Theme.currentTheme.separatorColor.cgColor
    }
}

extension UILabel {
    
    func detailPageTitleSet() {
        textColor = Theme.currentTheme.addIconTextColor
        font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    func timeLabelSet() {
        textColor = Theme.currentTheme.addIconTextColor
        font = UIFont.systemFont(ofSize: 15, weight: .light)
    }
}

extension UIImageView {
    
    func imageViewSet() {
        let tempImg = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tempImg
        self.tintColor = Theme.currentTheme.addIconTextColor
        transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }
}
