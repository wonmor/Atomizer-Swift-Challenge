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

    func purchase(_ product: Product?) async throws -> Transaction? {
        guard let result = try? await product?.purchase() else {
            return nil
        }

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await updatePurchasedIdentifiers(transaction)
            await transaction.finish()
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }

    func isPurchased(_ productIdentifier: String) async throws -> Bool {
        guard let result = await Transaction.latest(for: productIdentifier) else {
            return false
        }

        let transaction = try checkVerified(result)

        //Ignore revoked transactions, they're no longer purchased.
        //For subscriptions, a user can upgrade in the middle of their subscription period. The lower service
        //tier will then have the `isUpgraded` flag set and there will be a new transaction for the higher service
        //tier. Ignore the lower service tier transactions which have been upgraded.
        return transaction.revocationDate == nil && !transaction.isUpgraded
    }

    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            //StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    func updatePurchasedIdentifiers(_ transaction: Transaction) async {
        if transaction.revocationDate == nil {
            purchasedIdentifiers.insert(transaction.productID)
        } else {
            purchasedIdentifiers.remove(transaction.productID)
        }
    }

    func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.price < $1.price })
    }

    func restorePurchases() {
        Task {
            try? await AppStore.sync()
        }
    }
}
