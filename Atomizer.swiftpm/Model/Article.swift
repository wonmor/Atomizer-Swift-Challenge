import Foundation

/**
 * A model that represents an article.
 */

struct Article: Codable, Identifiable {
    let id: UUID
    let title: String
    let subtitle: String
    let imageUrl: String
    let content: String
    
    init(title: String, subtitle: String, imageUrl: String, content: String) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.imageUrl = imageUrl
        self.content = content
    }
}
