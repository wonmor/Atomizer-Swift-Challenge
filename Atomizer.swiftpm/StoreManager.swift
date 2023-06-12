import StoreKit

class StoreManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    static let shared = StoreManager() // Singleton instance
    
    @Published var purchasedProductIds: Set<String> = []
    @Published var buttonClickCount: Int = 0
    @Published var timeUntilReset: TimeInterval = 0 // in seconds
    private var resetTimer: Timer?
    
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
    
    func incrementButtonClickCount() {
           buttonClickCount += 1
           if buttonClickCount >= 3 {
               startResetTimer()
           }
       }
       
   private func startResetTimer() {
       timeUntilReset = 2 * 60 * 60 // 2 hours in seconds
       resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
           guard let self = self else { return }
           if self.timeUntilReset > 0 {
               self.timeUntilReset -= 1
           } else {
               self.resetButtonClickCount()
           }
       }
   }
   
   private func resetButtonClickCount() {
       buttonClickCount = 0
       resetTimer?.invalidate()
       resetTimer = nil
       timeUntilReset = 0
   }

    private func complete(transaction: SKPaymentTransaction) {
        // Handle successful purchase or restoration
    }

    private func fail(transaction: SKPaymentTransaction) {
        // Handle failed transaction
    }
}
