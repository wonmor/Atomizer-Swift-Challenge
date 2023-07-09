import StoreKit

class StoreManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    static let shared = StoreManager() // Singleton instance
    
    @Published var purchasedProductIds: Set<String> = []
    @Published var buttonClickCount: Int = 0
    @Published var timeUntilReset: TimeInterval = 0 // in seconds
    @Published var subscriptionExpirationDate: Date?
    
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
    
    func complete(transaction: SKPaymentTransaction) {
        if let productIdentifier: String? = transaction.payment.productIdentifier {
            purchasedProductIds.insert(productIdentifier!)
            
            print("Product Identifier: \(productIdentifier)")
        }
        
        if let product = products.first(where: { $0.productIdentifier == transaction.payment.productIdentifier }),
           let duration = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit,
           let component = calendarComponent(for: unit)
        {
            let calendar = Calendar.current
            var components = DateComponents()
            components.setValue(duration, for: component)
            
            if let expiryDate = calendar.date(byAdding: components, to: transaction.transactionDate ?? Date()) {
                subscriptionExpirationDate = expiryDate
                
                print("Expiry Date: \(expiryDate)")
            }
        }
        
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func calendarComponent(for unit: SKProduct.PeriodUnit) -> Calendar.Component? {
        switch unit {
        case .day:
            return .day
        case .week:
            return .weekOfMonth
        case .month:
            return .month
        case .year:
            return .year
        @unknown default:
            return nil
        }
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        // Handle failed transaction
        let alert = UIAlertController(title: "Payment Failed",
                                      message: "Your payment could not be processed.",
                                      preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        
        // Get the top-most view controller to present the alert
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
}
