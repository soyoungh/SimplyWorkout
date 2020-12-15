//
//  IAPService.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/12/15.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import Foundation
import StoreKit

class IAPService: NSObject {
    
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProduct() {
        let products: Set = [IAPProduct.nonConsumable.rawValue]
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
    }
    
    func restorePurchase() {
        paymentQueue.restoreCompletedTransactions()
    }
}

extension IAPService: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            
            switch transaction.transactionState {
            case .purchasing: break
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                UserDefaults.standard.set(true, forKey: "removeAds")
            default: queue.finishTransaction(transaction)
            }
        }
    }

}

extension SKPaymentTransactionState {
    
    func status() -> String {
        switch self {
        case .deferred: return "Deffered - "
        case .failed: return "Failed - "
        case .purchasing: return "Purchasing - "
        case .purchased: return "Purchased - "
        case .restored: return "Restored - "
        @unknown default:
            fatalError()
        }
    }
}
