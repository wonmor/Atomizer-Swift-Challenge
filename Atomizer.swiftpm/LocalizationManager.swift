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
                    "atoms": "원자 오비탈",
                    "molecules": "분자 오비탈",
                    "swift-winner": "Swift Student Challenge 2023 우승작",
                    "promo-text": "양자역학과",
                    "promo-text-2": "증강현실의 만남",
                    "readings": "읽어보기",
                    "bohr-article-title": "원자 모형의 변천사",
                    "homo-and-lumo-title": "결합/반결합 분자 오비탈"
                    // Add more key-value pairs for Korean
                ]
                return koreanDictionary[key] ?? key
            } else {
                // English (default)
                let englishDictionary: [String: String] = [
                    "explore": "Explore",
                    "atoms": "Atoms",
                    "molecules": "Molecules",
                    "swift-winner": "Swift Student Challenge 2023 Winner",
                    "promo-text": "Visualizing",
                    "promo-text-2": "Quantum Mechanics",
                    "readings": "Readings",
                    "bohr-article-title": "No More Bohr Diagrams.",
                    "homo-and-lumo-title": "HOMO and LUMO?"
                    
                    // Add more key-value pairs for English
                ]
                return englishDictionary[key] ?? key
            }
        }
        return key
    }
}
