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
    
    func getCurrentLocale() -> String {
        let locale = UserDefaults.standard.stringArray(forKey: "AppleLanguages")!
        if let languageCode: String? = locale[0] {
            return languageCode!
        } else {
            return "en"
        }
    }

    func localizedString(for key: String) -> String {
        let locale = UserDefaults.standard.stringArray(forKey: "AppleLanguages")!
        if let languageCode: String? = locale[0] {
            if languageCode!.starts(with: "ko") {
                // Korean
                let koreanDictionary: [String: String] = [
                    "explore": "둘러보기",
                    "atoms": "원자 오비탈",
                    "molecules": "분자 오비탈",
                    "article": "아티클",
                    "swift-winner": "Swift Student Challenge 2023 수상작",
                    "promo-text": "양자역학과",
                    "promo-text-2": "증강현실의 만남",
                    "readings": "읽어보기",
                    "bohr-article-title": "원자 모형의 변천사",
                    "homo-and-lumo-title": "결합/반결합 분자 오비탈",
                    "explore-explain": "모든 시각 자료들은 SciPy, PySCF, and GPAW을 이용해 만들어졌음을 알려드립니다.",
                    "credit": "이용해주셔서 감사합니다, 개발자 성원모 (John Seong) 올림.",
                    "atoms-promo-text": "Atomizer AR은 구면조화 함수를 이용해 파동함수를 표현합니다.\n또한, 메트로폴리스-해스팅스 알고리즘을 이용해 직접적으로 표본을 얻기 어려운 확률 분포로부터 수열을 생성합니다.",
                    "molecules-promo-text": "Atomizer AR은 밀도범함수이론 (DFT) 을 이용해 전자 밀도를 계산합니다.\n분자 오비탈의 경우에는, 바닥상태의 파동 함수와 에너지를 구할 때 사용되는 근사 방법인 하트리-폭 (HF) 방법을 이용합니다.",
                    "homo": "결합",
                    "lumo": "반결합",
                    "electron-config": "전자 배치",
                    "swift-challenge": "Swift 학생 챌린지"
                    // Add more key-value pairs for Korean
                ]
                return koreanDictionary[key] ?? key
            } else {
                // English (default)
                let englishDictionary: [String: String] = [
                    "explore": "Explore",
                    "atoms": "Atoms",
                    "molecules": "Molecules",
                    "article": "Article",
                    "swift-winner": "Swift Student Challenge 2023 Winner",
                    "promo-text": "Visualizing",
                    "promo-text-2": "Quantum Mechanics",
                    "readings": "Readings",
                    "bohr-article-title": "No More Bohr Diagrams.",
                    "homo-and-lumo-title": "HOMO and LUMO?",
                    "explore-explain": "All visuals were generated from scratch using SciPy, PySCF, and GPAW.",
                    "credit": "Developed and Designed by John Seong",
                    "atoms-promo-text": "Atomizer AR uses Spherical Harmonics and Metropolis-Hastings algorithm to plot atomic orbitals.",
                    "molecules-promo-text": "Atomizer AR uses DFT calculations to derive electron density, and Hatree-Fock method to plot molecular orbitals.",
                    "homo": "HOMO",
                    "lumo": "LUMO",
                    "electron-config": "Electron Config.",
                    "swift-challenge": "Swift Student Challenge!"
                    
                    // Add more key-value pairs for English
                ]
                return englishDictionary[key] ?? key
            }
        }
        return key
    }
}
