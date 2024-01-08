import StoreKit
import SwiftUI

enum SubscriptionStatus: Equatable {
    static func == (lhs: SubscriptionStatus, rhs: SubscriptionStatus) -> Bool {
        switch (lhs, rhs) {
        case (.subscribed, .subscribed), (.notSubscribed, .notSubscribed):
            return true
        case let (.error(error1), .error(error2)):
            // Compare errors if both cases are errors
            return (error1 as NSError) == (error2 as NSError)
        default:
            return false
        }
    }
    
    case subscribed
    case notSubscribed
    case error(Error)
}

struct AlertItem: Identifiable {
    var id = UUID()
    var title: String
    var message: String?
    var dismissButtonTitle: String
    var action: (() -> Void)? = nil
}

class StoreKitManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var subscriptionStatus: SubscriptionStatus?
    @Published var availableProducts: [SKProduct] = []
    @Published var alert: AlertItem?
    
    static let shared = StoreKitManager()
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        checkSubscriptionStatus()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.isEmpty {
            print("No products available")
            return
        }
        
        availableProducts = response.products
        for product in availableProducts {
            print("Product ID: \(product.productIdentifier)")
            print("Title: \(product.localizedTitle)")
            print("Price: \(product.price)")
        }
    }
    
    func fetchProducts(productIdentifiers: Set<String>) {
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
    
    func checkSubscriptionStatus() {
        guard let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
              FileManager.default.fileExists(atPath: appStoreReceiptURL.path) else {
            subscriptionStatus = .notSubscribed
            return
        }
        
        let request = SKReceiptRefreshRequest(receiptProperties: nil)
        request.delegate = self
        
        request.start()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                subscriptionStatus = .subscribed
                
            case .failed:
                subscriptionStatus = .notSubscribed
                
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    func purchaseSubscription(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        
        if !queue.transactions.isEmpty {
            for transaction in queue.transactions {
                handleRestoredTransaction(transaction)
            }
        } else {
            alert = AlertItem(
                title: "Nothing Found to Restore",
                message: "It doesn't appear you have ever made a purchase.",
                dismissButtonTitle: "OK"
            )
        }
    }
    
    func handleRestoredTransaction(_ transaction: SKPaymentTransaction) {
        switch transaction.transactionState {
        case .purchased, .restored:
            alert = AlertItem(
                title: "Success",
                message: "Thanks for subscribing!",
                dismissButtonTitle: "OK"
            )
            
        case .failed:
            if let error = transaction.error {
                alert = AlertItem(
                    title: "Transaction Failed",
                    message: error.localizedDescription,
                    dismissButtonTitle: "OK"
                )
            }
            
        case .deferred, .purchasing:
            break
            
        @unknown default:
            break
        }
    }
}


extension StoreKitManager: SKRequestDelegate {
    func requestDidFinish(_ request: SKRequest) {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
           FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            self.subscriptionStatus = .subscribed
        } else {
            self.subscriptionStatus = .notSubscribed
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        self.subscriptionStatus = .error(error)
        self.alert = AlertItem(
            title: "Unable to Check Subscription Status",
            message: error.localizedDescription,
            dismissButtonTitle: "OK"
        )
    }
}
