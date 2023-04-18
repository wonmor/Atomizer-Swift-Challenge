import Foundation


class ArticleViewModel: ObservableObject {
    @Published var articles = [Article]()
    
    init() {
        guard let url = URL(string: "https://electronvisual.org/api/get-articles") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([Article].self, from: data)
                DispatchQueue.main.async {
                    self.articles = decodedData
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
