import Foundation
import Combine

class WebViewModel: ObservableObject {
    @Published var intention: String = ""

    func updateIntention(value: String) {
        intention = value
    }
}
