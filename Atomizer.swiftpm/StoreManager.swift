import Foundation
import Combine
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

class StoreManager {
    static let shared = StoreManager(productIds: [])
    private(set) var nonConsumables: [Product] = []
    private(set) var consumables: [Product] = []
    private(set) var subscriptions: [Product] = []
    var purchasedIdentifiers = Set<String>()

    var updateListenerTask: Task<Void, Error>? = nil

    private let productIds: [String]

    init(productIds: [String]) {
        self.productIds = productIds

        //Start a transaction listener as close to app launch as possible so you don't miss any transactions.
        updateListenerTask = listenForTransactionsThatHappenedOutsideTheApp()
    }

    deinit {
        updateListenerTask?.cancel()
    }

    func listenForTransactionsThatHappenedOutsideTheApp() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await self.updatePurchasedIdentifiers(transaction)

                    //Always finish a transaction.
                    await transaction.finish()
                } catch {
                    //StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                }
            }
        }
    }

    func requestProducts() async {
        do {
            let storeProducts = try await Product.products(for: productIds)
            var newNonConsumables: [Product] = []
            var newSubscriptions: [Product] = []
            var newConsumables: [Product] = []

            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newConsumables.append(product)
                case .nonConsumable:
                    newNonConsumables.append(product)
                case .autoRenewable:
                    newSubscriptions.append(product)
                default:
                    break
                }
            }

            nonConsumables = sortByPrice(newNonConsumables)
            subscriptions = sortByPrice(newSubscriptions)
            consumables = sortByPrice(newConsumables)
        } catch {
            // Handle error here.
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
