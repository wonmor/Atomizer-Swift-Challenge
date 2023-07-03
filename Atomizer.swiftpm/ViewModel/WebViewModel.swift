import Foundation
import Combine

class WebViewModel: ObservableObject {
    // Javascript to iOS
    @Published var intention: String = ""
    @Published var metadata: Dictionary<String, Any>? = nil
    
    func setIntention(message: String) -> Void {
        DispatchQueue.main.async {
            self.intention = message
        }
    }
    
    func setMetadata(data: String) {
        guard let jsonData = data.data(using: .utf8) else {
            return
        }
        
        do {
            guard let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                return
            }
            
            DispatchQueue.main.async {
                self.metadata = jsonObject
            }
        } catch {
            print("Error parsing JSON data: \(error)")
        }
    }
}
