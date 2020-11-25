//
//  InAppPurchaseCtrl.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/29.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//  productId = "com.soyoungHyun.SimplyWorkout.removeAds"

import UIKit
import SwiftyStoreKit

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
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var upgradeBtn: UIButton!
    @IBOutlet weak var restoreBtn: UIButton!
    @IBOutlet weak var proBox: UIView!
    
    let IAPPurchaseIDs = [["com.soyoungHyun.SimplyWorkout.ncRemoveAds"]]
    let sharedSecret = "c620d1374ee34cd88444245fa7f27e2d"

    override func viewDidLoad() {
        super.viewDidLoad()
        presetup()
        
        for i in 0...IAPPurchaseIDs.count - 1 {
            for j in 0...IAPPurchaseIDs[i].count - 1 {
                SwiftyStoreKit.retrieveProductsInfo([IAPPurchaseIDs[i][j]]) { result in
                    if let product = result.retrievedProducts.first {
                        let priceString = product.localizedPrice!
                        print("Product: \(product.localizedDescription), price: \(priceString)")
                        
                        switch i {
                        case 0:
                            self.verifyPurchase(with: self.IAPPurchaseIDs[0][0], sharedSecret: self.sharedSecret)
                        default:
                            break
                        }
                    }
                    else if let invalidProductId = result.invalidProductIDs.first {
                        print("Invalid product identifier: \(invalidProductId)")
                    }
                    else {
                        print("Error: \(String(describing: result.error))")
                    }
                }
            }
        }
    }
    
    func purchaseProduct(with id: String) {
        SwiftyStoreKit.retrieveProductsInfo([id]) { result in
            if let product = result.retrievedProducts.first {
                SwiftyStoreKit.purchaseProduct(product, quantity: 1, atomically: true) { result in
                    switch result {
                    case .success(let purchase):
                        print("Purchase Success: \(purchase.productId)")
                        self.dismiss(animated: true, completion: nil)
                    case .error(let error):
                        switch error.code {
                        case .unknown: print("Unknown error. Please contact support")
                        case .clientInvalid: print("Not allowed to make the payment")
                        case .paymentCancelled: break
                        case .paymentInvalid: print("The purchase identifier was invalid")
                        case .paymentNotAllowed: print("The device is not allowed to make the payment")
                        case .storeProductNotAvailable: print("The product is not available in the current storefront")
                        case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                        case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                        case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                        default: print((error as NSError).localizedDescription)
                            
                        }
                    }
                }
            }
        }
    }
    
    func verifyPurchase(with id: String, sharedSecret: String) {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: sharedSecret)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { result in
            switch result {
            case .success(let receipt):
                let productId = id
                // Verify the purchase of Consumable or NonConsumable
                let purchaseResult = SwiftyStoreKit.verifyPurchase(
                    productId: productId,
                    inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let receiptItem):
                    print("Product is purchased: \(receiptItem)")
                case .notPurchased:
                    print("The user has never purchased \(productId)")
                }
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    @objc func cancelBtnDidTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func upgradeBtnDidTapped() {
        purchaseProduct(with: IAPPurchaseIDs[0][0])
    }
    
    @objc func restoreBtnDidTapped() {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            }
            else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
        }
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
        
        restoreBtn.tintColor = Theme.currentTheme.opacityText
        restoreBtn.addTarget(self, action: #selector(restoreBtnDidTapped), for:     .touchUpInside)
    }
    
}
