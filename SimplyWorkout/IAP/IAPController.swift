//
//  IAPController.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/12/15.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import Foundation
import UIKit

class IAPController: UIViewController {
   
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
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var proBox: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presetup()
        IAPService.shared.getProduct()
    }
    
    // MARK: - View Layout setup
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
        removeAdsTitle.text = NSLocalizedString("Remove all Ads", comment: "iap_page_removeAdsTitle")
        reportTitle.textColor = Theme.currentTheme.headerTitleColor
        reportTitle.text = NSLocalizedString("Monthly workout report", comment: "iap_page_reportTitle")
        darkmodeTitle.textColor = Theme.currentTheme.headerTitleColor
        darkmodeTitle.text = NSLocalizedString("Dark Theme", comment: "iap_popup_darkmodeTitle")
        popupTitle.detailPageTitleSet()
        popupTitle.text = NSLocalizedString("SIMPLY WORKOUT PRO", comment: "iap_page_popupTitle")
        
        subLabel_ads.textColor = Theme.currentTheme.opacityText
        subLabel_ads.text = NSLocalizedString("Enjoy your app without annoying ads!", comment: "iap_adsText")
        subLabel_report.textColor = Theme.currentTheme.opacityText
        subLabel_report.text = NSLocalizedString("You will get the monthly statistics for your activity.", comment: "iap_reportText")
        subLabel_darkmode.textColor = Theme.currentTheme.opacityText
        subLabel_darkmode.text = NSLocalizedString("You will get a dark appearance and synchronize the same as your device setting.", comment: "iap_darkmodeText")
        
        cancelBtn.tintColor = Theme.currentTheme.accentColor
        cancelBtn.addTarget(self, action: #selector(cancelBtnDidTapped), for: .touchUpInside)
        
        upgradeBtn.roundedCornerBtn()
        upgradeBtn.backgroundColor = Theme.currentTheme.accentColor
        upgradeBtn.tintColor = Theme.currentTheme.textColorInDarkBg
        upgradeBtn.addTarget(self, action: #selector(upgradeBtnDidTapped), for: .touchUpInside)
        upgradeBtn.setTitle(NSLocalizedString("Upgrade for $1.99", comment: "iap_popup_upgradeBtn"), for: .normal)
        
        restoreBtn.tintColor = Theme.currentTheme.opacityText
        restoreBtn.addTarget(self, action: #selector(restoreBtnDidTapped), for:     .touchUpInside)
        restoreBtn.setTitle(NSLocalizedString("Restore purchase", comment: "iap_popup_restoreBtn"), for: .normal)
    }
    
    @objc func cancelBtnDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func upgradeBtnDidTapped() {
        IAPService.shared.purchase(product: .nonConsumable)
    }
    
    @objc func restoreBtnDidTapped() {
        IAPService.shared.restorePurchase()
    }
}
