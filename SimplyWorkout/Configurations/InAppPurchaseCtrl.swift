//
//  InAppPurchaseCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/29.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//  productId = "com.soyoungHyun.SimplyWorkout.removeAds"

import UIKit
import StoreKit

class InAppPurchaseCtrl: UIViewController {
    
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var removeAdsTitle: UILabel!
    @IBOutlet weak var enjoyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var popupView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetup()
        IAPHelper.shared.getProduct()
    }
    
    func presetup() {
        popupView.backgroundColor = Theme.currentTheme.backgroundColor
        popupView.layer.cornerRadius = 10
        
        removeAdsTitle.textColor = Theme.currentTheme.headerTitleColor
        popupTitle.detailPageTitleSet()
        
        enjoyLabel.textColor = Theme.currentTheme.textColor
        priceLabel.textColor = Theme.currentTheme.textColor
        
        cancelBtn.roundedCornerBtn()
        cancelBtn.titleLabel!.font = UIFont.systemFont(ofSize: 15, weight: .light)
        cancelBtn.backgroundColor = Theme.currentTheme.cancelBtnColor
        cancelBtn.tintColor = Theme.currentTheme.weekdayTextColor
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidTapped), for: .touchUpInside)
        
        upgradeBtn.roundedCornerBtn()
        upgradeBtn.backgroundColor = Theme.currentTheme.accentColor
        upgradeBtn.tintColor = Theme.currentTheme.textColorInDarkBg
        upgradeBtn.addTarget(self, action: #selector(upgradeBtnDidTapped), for: .touchUpInside)
        
    }
    
    @objc func cancelBtnDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func upgradeBtnDidTapped() {
        IAPHelper.shared.purchase(product: .nonConsumable)
        dismiss(animated: true, completion: nil)
    }
    
   

}
