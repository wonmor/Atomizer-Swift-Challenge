import Foundation
import Combine

class WebViewModel: ObservableObject {
    // Javascript to iOS
    var intention = PassthroughSubject<String, Never>()
}
