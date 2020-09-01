//
//  ColorTagCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 20/07/2020.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import UIKit

class ColorTagCtrl: NSObject, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let colorTag = [AssetsColor.floraFirma, .bodacious, .sulphurSpring, .pinkLemonade, .summerStorm, .oriole, .barrierReef, .citrusSol, .butterRum, .turquoise, .ibizaBlue, .raspberries]
    
    var selectedColor: String?
    var firstSelectionIndexPath: IndexPath?
    var indexContainer = [IndexPath]()
    
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
        
        let cell = collectionView.cellForItem(at: indexPath) as! ColorTagCell
        let tag = colorTag[indexPath.row]
        
        if firstSelectionIndexPath == nil {
            firstSelectionIndexPath = indexPath
            indexContainer.insert(firstSelectionIndexPath!, at: 0)
            //print("\(indexContainer) #1")
            print("\(tag) #1")
            if indexContainer.count == 3 {
                let tempCell = collectionView.cellForItem(at: indexContainer[2]) as! ColorTagCell
                tempCell.deselectCell()
                indexContainer.remove(at: 1)
                indexContainer.removeLast()
                // print("\(indexContainer) #3")
            }
        }
        else {
            checkForSelectedTag(collectionView, indexPath)
        }
        cell.selectCell()
        selectedColor = "\(tag)"
    }
    
    func checkForSelectedTag(_ collectionView: UICollectionView, _ secondSelectionIndexPath: IndexPath) {
        
        let firstCell = collectionView.cellForItem(at: firstSelectionIndexPath!) as! ColorTagCell
        let secondCell = collectionView.cellForItem(at: secondSelectionIndexPath) as! ColorTagCell
        let secondTag = colorTag[secondSelectionIndexPath.row]
        
        // Select only one cell at a time
        // Send the name of the selected color chip
        
        if firstSelectionIndexPath != secondSelectionIndexPath {
            secondCell.selectCell()
            firstCell.deselectCell()
            selectedColor = "\(secondTag)"
            indexContainer.append(secondSelectionIndexPath)
            firstSelectionIndexPath = nil
            // print("\(indexContainer) #2")
            print("\(secondTag) #2")
        }
    }
}

extension ColorTagCtrl: UICollectionViewDelegateFlowLayout {
    
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


