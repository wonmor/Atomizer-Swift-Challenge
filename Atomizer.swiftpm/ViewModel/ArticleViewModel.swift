import Foundation

class ArticleViewModel: ObservableObject {
    @Published var articles = [Article]()
    
    let localizationManager = LocalizationManager.shared
    
    init() {
        if let path = Bundle.main.path(forResource: localizationManager.getCurrentLocale().starts(with: "ko") ? "ko_articles" : "articles", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let decodedData = try JSONDecoder().decode([Article].self, from: data)
                self.articles = decodedData
            } catch {
                print(error)
            }
        } else {
            print("articles.json not found")
        }
    }
}
