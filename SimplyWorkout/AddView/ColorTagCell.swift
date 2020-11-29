//
//  ColorTagCell.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 20/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class ColorTagCell: UICollectionViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    var tagName = AssetsColor(rawValue: "floraFirma")
    
    let firstLayer = CALayer()
    let secondLayer = CALayer()
  
    func setCell(_ tagName: AssetsColor) {
        
        self.tagName = tagName
   
        firstLayer.frame.size = CGSize(width: 24, height: 24)
        firstLayer.cornerRadius = firstLayer.bounds.width / 2
        firstLayer.backgroundColor = UIColor(named: tagName.rawValue)?.cgColor
        firstLayer.position = CGPoint(x: 16, y: 16)
        
        cellView.layer.addSublayer(firstLayer)
    }
    
    func selectCell() {
        
        secondLayer.frame.size = CGSize(width: 32, height: 32)
        secondLayer.cornerRadius = secondLayer.bounds.width / 2
        secondLayer.backgroundColor = UIColor.clear.cgColor
        secondLayer.borderColor = Theme.currentTheme.headerTitleColor.cgColor
        secondLayer.borderWidth = 1.3
        secondLayer.opacity = 0.6
        
        layer.addSublayer(secondLayer)
        
    }
    
    func deselectCell() {
        
        secondLayer.removeFromSuperlayer()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                selectCell()
            }
            else {
                deselectCell()
            }
        }
    }
}
