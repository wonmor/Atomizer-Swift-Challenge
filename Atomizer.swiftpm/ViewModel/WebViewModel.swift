import Foundation
import Combine

class WebViewModel: ObservableObject {
    // Javascript to iOS
    @Published var intention: String = ""
    
    func setIntention(message: String) -> Void {
        DispatchQueue.main.async {
            self.intention = message
        }
    }
}
