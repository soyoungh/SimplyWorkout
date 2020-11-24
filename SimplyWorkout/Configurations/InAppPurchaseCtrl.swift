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
    @IBOutlet weak var adShieldIcon: UIImageView!
    @IBOutlet weak var removeAdsTitle: UILabel!
    @IBOutlet weak var subLabel_ads: UILabel!
    @IBOutlet weak var chartIcon: UIImageView!
    @IBOutlet weak var reportTitle: UILabel!
    @IBOutlet weak var subLabel_report: UILabel!
    @IBOutlet weak var darkmodeIcon: UIImageView!
    @IBOutlet weak var darkmodeTitle: UILabel!
    @IBOutlet weak var subLabel_darkmode: UILabel!
    @IBOutlet weak var restoreLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var proBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetup()
        IAPHelper.shared.getProduct()
    }
    
    func presetup() {
        view.backgroundColor = Theme.currentTheme.backgroundColor
        
        proBox.backgroundColor = Theme.currentTheme.lightCellColor
        proBox.layer.cornerRadius = 10
        proBox.layer.shadowColor = UIColor.black.cgColor
        proBox.layer.shadowOpacity = 0.2
        proBox.layer.shadowRadius = 10
        proBox.layer.shadowOffset = .zero
        proBox.layer.shadowPath = UIBezierPath(rect: proBox.bounds).cgPath
        proBox.layer.shouldRasterize = true
        proBox.layer.rasterizationScale = UIScreen.main.scale
      
        removeAdsTitle.textColor = Theme.currentTheme.headerTitleColor
        reportTitle.textColor = Theme.currentTheme.headerTitleColor
        darkmodeTitle.textColor = Theme.currentTheme.headerTitleColor
        popupTitle.detailPageTitleSet()
        
        subLabel_ads.textColor = Theme.currentTheme.opacityText
        subLabel_report.textColor = Theme.currentTheme.opacityText
        subLabel_darkmode.textColor = Theme.currentTheme.opacityText
        
        cancelBtn.tintColor = Theme.currentTheme.accentColor
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
