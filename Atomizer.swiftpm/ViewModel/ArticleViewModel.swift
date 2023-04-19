import Foundation

class ArticleViewModel: ObservableObject {
    @Published var articles = [Article]()
    
    init() {
        if let path = Bundle.main.path(forResource: "articles", ofType: "json") {
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
