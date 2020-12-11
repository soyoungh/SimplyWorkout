//
//  ColorTagCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 20/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class CategoryColorCtrl: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let colorTag = [AssetsColor.floraFirma, .chiveBlossom, .sulphurSpring, .pinkLemonade, .summerStorm, .oriole, .deepLake, .citrusSol, .butterRum, .turquoise, .ibizaBlue, .vivacious]
    
    var selectedColor: String?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorTag.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagCell", for: indexPath) as! ColorTagCell
        
        let tag = colorTag[indexPath.row]
        
        cell.frame.size = CGSize(width:32, height: 32)
        cell.backgroundColor = UIColor.clear
        cell.setCell(tag)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = colorTag[indexPath.row]
        selectedColor = "\(tag)"
    }
}

extension CategoryColorCtrl: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 30, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 10, left: 17, bottom: 10, right: 17)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var space = CGFloat()
        
        if collectionView.frame.size.width > 340 {
            
            space = 25
        }
        else {
            space = 16
        }
        
        return space
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


