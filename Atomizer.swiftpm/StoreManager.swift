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
    
    private let resetTimerKey = "resetTimer"
    private let timeDelay: Double = 2 * 60 * 60 // 2 hours in seconds
    
    override init() {
        super.init()
        restorePreviousState()
    }
    
    func requestProducts(withIdentifiers identifiers: Set<String>) {
        productRequest?.cancel()
        productRequest = SKProductsRequest(productIdentifiers: identifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    func getProducts() -> [SKProduct] {
        return products
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
    
    func incrementButtonClickCount() -> Bool {
        guard timeUntilReset <= 0 else {
            // User still needs to wait
            print("User still needs to wait!")
            
            return false
        }
        
        buttonClickCount += 1
        
        print("Incrementing button click count...")
        
        if buttonClickCount >= 2 {
            print("Starting the timer...")
            
            startResetTimer()
        }
        return true
    }
    
    func hasActiveMembership() -> String {
        guard let expirationDate = subscriptionExpirationDate else {
            // No expiration date set
            guard let latestTransaction = retrieveLatestTransaction() else {
                return "none"
            }
            
            if let product = products.first(where: { $0.productIdentifier == latestTransaction.payment.productIdentifier }),
               let duration = product.subscriptionPeriod?.numberOfUnits,
               let unit = product.subscriptionPeriod?.unit,
               let component = calendarComponent(for: unit)
            {
                let calendar = Calendar.current
                var components = DateComponents()
                components.setValue(duration, for: component)
                
                if let expiryDate = calendar.date(byAdding: components, to: latestTransaction.transactionDate ?? Date()) {
                    subscriptionExpirationDate = expiryDate
                    
                    print("Expiry Date: \(expiryDate)")
                    
                    return product.productIdentifier // Return the product identifier as a string
                }
            }
            
            return "none"
        }
        
        let currentDate = Date()
        
        if currentDate < expirationDate {
            // Current date is before the expiration date, membership is active
            return products.first?.productIdentifier ?? "none" // Return the product identifier as a string
        } else {
            // Current date is after the expiration date, membership is inactive
            return "none"
        }
    }

    private func retrieveLatestTransaction() -> SKPaymentTransaction? {
        guard let transaction = SKPaymentQueue.default().transactions.last else {
            return nil
        }
        
        // Check if the transaction is completed or restored
        if transaction.transactionState == .purchased || transaction.transactionState == .restored {
            return transaction
        }
        
        return nil
    }
    
    private func startResetTimer() {
         timeUntilReset = self.timeDelay // 2 hours in seconds
         resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
             guard let self = self else { return }
             if self.timeUntilReset > 0 {
                 self.timeUntilReset -= 1
                 UserDefaults.standard.set(self.timeUntilReset, forKey: self.resetTimerKey)
             } else {
                 self.resetButtonClickCount()
             }
         }
         
         // Save the timer start time
         let startTime = Date()
         UserDefaults.standard.set(startTime, forKey: resetTimerKey)
     }
     
    func restorePreviousState() {
        if let startTime = UserDefaults.standard.object(forKey: resetTimerKey) as? Date {
            let elapsedTime = Date().timeIntervalSince(startTime)
            let remainingTime = max(0, self.timeDelay - elapsedTime)
            timeUntilReset = remainingTime
            
            if remainingTime > 0 {
                resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
                    self?.timeUntilReset -= 1
                    if self?.timeUntilReset ?? 0 <= 0 {
                        self?.resetButtonClickCount()
                    }
                }
            } else {
                resetButtonClickCount()
            }
        }
    }
    
    private func resetButtonClickCount() {
           buttonClickCount = 0
           resetTimer?.invalidate()
           resetTimer = nil
           timeUntilReset = 0
           UserDefaults.standard.removeObject(forKey: resetTimerKey)
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
    
    static func displayErrorMessage(title: String, message: String) {
        // Handle failed transaction
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        
        // Get the top-most view controller to present the alert
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
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
        StoreManager.displayErrorMessage(title: "Payment Failed", message: "Your payment could not be processed.")
    }
}
