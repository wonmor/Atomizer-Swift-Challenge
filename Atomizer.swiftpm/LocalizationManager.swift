//
//  A Singleton class
//  Atomizer AR
//
//  Created by John Seong on 2023-05-12.
//

import Foundation

class LocalizationManager {
    static let shared = LocalizationManager()

    private init() {}

    func localizedString(for key: String) -> String {
        let locale = Locale.current
        if let languageCode = locale.languageCode {
            if languageCode.starts(with: "ko") {
                // Korean
                let koreanDictionary: [String: String] = [
                    "explore": "둘러보기",
                    "goodbye": "안녕히 계세요",
                    // Add more key-value pairs for Korean
                ]
                return koreanDictionary[key] ?? key
            } else {
                // English (default)
                let englishDictionary: [String: String] = [
                    "explore": "Explore",
                    "goodbye": "Goodbye",
                    // Add more key-value pairs for English
                ]
                return englishDictionary[key] ?? key
            }
        }
        return key
    }
}
