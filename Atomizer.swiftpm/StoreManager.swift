import StoreKit

class StoreManager: NSObject, ObservableObject {
    static let shared = StoreManager()
    
    @Published var purchasedProductIds: Set<String> = []
    @Published var buttonClickCount: Int = 0
    @Published var timeUntilReset: TimeInterval = 0
    @Published var subscriptionExpirationDate: Date?
    
    private var resetTimer: Timer?
    private let resetTimerKey = "resetTimer"
    private let timeDelay: TimeInterval = 2 * 60 * 60 // 2 hours in seconds
    
    func incrementButtonClickCount() -> Bool {
        guard timeUntilReset <= 0 else {
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
    
    private func startResetTimer() {
        timeUntilReset = timeDelay
        resetTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.timeUntilReset > 0 {
                self.timeUntilReset -= 1
                UserDefaults.standard.set(self.timeUntilReset, forKey: self.resetTimerKey)
            } else {
                self.resetButtonClickCount()
            }
        }
        
        let startTime = Date()
        UserDefaults.standard.set(startTime, forKey: resetTimerKey)
    }
    
    func restorePreviousState() {
        if let startTime = UserDefaults.standard.object(forKey: resetTimerKey) as? Date {
            let elapsedTime = Date().timeIntervalSince(startTime)
            let remainingTime = max(0, timeDelay - elapsedTime)
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

    static func displayErrorMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okayAction)
        
        if let topViewController = UIApplication.shared.windows.first?.rootViewController {
            topViewController.present(alert, animated: true, completion: nil)
        }
    }
    
    private func getCurrentDate() -> Date? {
        let currentDate = Date()
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: currentDate)
    }
}


