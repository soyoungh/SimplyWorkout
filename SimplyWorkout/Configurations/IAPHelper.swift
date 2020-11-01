//
//  IAPHelper.swift
//  SimplyWorkout
//
//  Created by Soyoung Hyun on 2020/10/30.
//  Copyright © 2020 soyoung hyun. All rights reserved.
//

import Foundation
import StoreKit

class IAPHelper: NSObject {
    
    private override init() {}
    static let shared = IAPHelper()
    
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
    
}

extension IAPHelper: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {  
        self.products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPHelper: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState {
            case .purchasing:
                break
            default: queue.finishTransaction(transaction)
            }
        }
    }
}

extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred:
            return "Payment is deferred."
        case .failed:
            return "Payment is failed."
        case .purchased:
            return "Purchased successfully."
        case .purchasing:
            return "avilable for purchasing."
        case .restored:
            return "Payment is restored."
        @unknown default:
            fatalError()
        }
    }
}
