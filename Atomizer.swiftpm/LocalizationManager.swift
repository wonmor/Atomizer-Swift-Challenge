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
    
    // Detect device language... https://stackoverflow.com/questions/67516514/how-to-get-system-device-language-swift-ios

    func localizedString(for key: String) -> String {
        let locale = UserDefaults.standard.stringArray(forKey: "AppleLanguages")!
        if let languageCode: String? = locale[0] {
            if languageCode!.starts(with: "ko") {
                // Korean
                let koreanDictionary: [String: String] = [
                    "explore": "둘러보기",
                    "atoms": "원자 오비탈",
                    "molecules": "분자 오비탈",
                    "swift-winner": "Swift Student Challenge 2023 수상작",
                    "promo-text": "양자역학과",
                    "promo-text-2": "증강현실의 만남",
                    "readings": "읽어보기",
                    "bohr-article-title": "원자 모형의 변천사",
                    "homo-and-lumo-title": "결합/반결합 분자 오비탈",
                    "explore-explain": "모든 시각 자료들은 SciPy, PySCF, and GPAW을 이용해 만들어졌음을 알려드립니다.",
                    "credit": "이용해주셔서 감사합니다, 개발자 성원모 올림."
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
                    "homo-and-lumo-title": "HOMO and LUMO?",
                    "explore-explain": "All visuals were generated from scratch using SciPy, PySCF, and GPAW.",
                    "credit": "Developed and Designed by John Seong"
                    
                    // Add more key-value pairs for English
                ]
                return englishDictionary[key] ?? key
            }
        }
        return key
    }
}
