import StoreKit

class StoreManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    static let shared = StoreManager() // Singleton instance
    
    @Published var purchasedProductIds: Set<String> = []
    private var products: [SKProduct] = []
    private var productRequest: SKProductsRequest?
    
    func requestProducts(withIdentifiers identifiers: Set<String>) {
        productRequest?.cancel()
        productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                complete(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
        }
    }

    private func complete(transaction: SKPaymentTransaction) {
        // Handle successful purchase or restoration
    }

    private func fail(transaction: SKPaymentTransaction) {
        // Handle failed transaction
    }
}
