import SwiftUI
import Introspect
import WebKit
import Network

/**
 A view that displays an article.
 
 ATOMIZER
 Developed and Designed by John Seong.
 */

struct NoNetworkView: View {
    var body: some View {
        ZStack {
            Color.black // Set the background color to black
            
            Text("No network connection")
                .foregroundColor(.white) // Set the text color to white
                .font(.title) // Adjust the font size if needed
        }
    }
}

struct ExploreView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedView: Int?
    @Binding var isShowingSheet: Bool
    
    @State private var lastHostingView: UIView!
    @State private var intention: String = ""
    
    @ObservedObject var articleData = ArticleViewModel()
    @ObservedObject var webViewModel = WebViewModel()
    
    var body: some View {
        // A basic finite-state machine
        switch webViewModel.intention {
        case "":
            if (webViewModel.metadata == nil) {
                webViewWrapper()
                
            } else {
                switch webViewModel.metadata?["type"] {
                case let type as String where type == "molecule":
                    if let formula = webViewModel.metadata?["formula"] as? String {
                        if (StoreManager.shared.hasActiveMembership()) {
                            if loadMolecule(formula: formula) != nil {
                                MoleculeDetailView(molecule: loadMolecule(formula: formula)!)
                            }
                        } else {
                            webViewWrapper()
                                .onAppear() {
                                    isShowingSheet = true
                                }
                        }
                        
                        // Do NOT change selectedView variable here. It will break the code.
                    }
                    
                case let type as String where type == "atom":
                    if let formula = webViewModel.metadata?["formula"] as? String {
                        if (StoreManager.shared.hasActiveMembership()) {
                            if loadElement(formula: formula) != nil {
                                AtomDetailView(element: loadElement(formula: formula)!)
                            }
                        } else {
                            webViewWrapper()
                                .onAppear() {
                                    isShowingSheet = true
                                }
                        }
                        
                        // Do NOT change selectedView variable here. It will break the code.
                    }
                    
                default:
                    webViewWrapper()
                }
            }
            
        case "OPEN_ATOM_PAGE":
            AtomView(isShowingSheet: $isShowingSheet)
                .onAppear() {
                    selectedView = 1
                }
            
        case "OPEN_MOLECULE_PAGE":
            MoleculeView(isShowingSheet: $isShowingSheet)
                .onAppear() {
                    selectedView = 2
                }
            
        case "NO_NETWORK":
            NoNetworkView()
                .onAppear() {
                    selectedView = nil
                }

            
        default:
            webViewWrapper()
        }
    }
    
    func loadElement(formula: String) -> Element? {
        let localizationManager = LocalizationManager.shared
        let jsonURL = Bundle.main.url(forResource: localizationManager.getCurrentLocale().starts(with: "ko") ? "ko_atoms" : "atoms", withExtension: "json")!
        let jsonData = try! Data(contentsOf: jsonURL)
        let decoder = JSONDecoder()
        let elements = try! decoder.decode([Element].self, from: jsonData)
        
        for element in elements {
            if (element.symbol == formula) {
                return element
            }
        }
        
        return nil
    }
    
    func loadMolecule(formula: String) -> Molecule? {
        guard let url = Bundle.main.url(forResource: localizationManager.getCurrentLocale().starts(with: "ko") ? "ko_molecules" : "molecules", withExtension: "json") else { return nil }
        
        do {
            let data = try Data(contentsOf: url)
            let molecules: [Molecule] = try JSONDecoder().decode([Molecule].self, from: data)
            
            for molecule in molecules {
                if (molecule.formula == formula) {
                    return molecule
                }
            }
            
            return nil
            
        } catch {
            print("Error loading JSON: \(error.localizedDescription)")
            
            return nil
        }
    }
    
    static func isNetworkAvailable() -> Bool {
        let monitor = NWPathMonitor()
        let semaphore = DispatchSemaphore(value: 0)
        
        var isAvailable = false
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isAvailable = true
            }
            semaphore.signal()
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        
        _ = semaphore.wait(timeout: .now() + 5) // Wait for 5 seconds to check network availability
        
        return isAvailable
    }
    
    func webViewWrapper() -> some View {
        return (
            ZStack {
                Color.black // Set the background color to black
                
                WebView(urlString: "https://electronvisual.org?fullscreen=true", viewModel: webViewModel)
                    .ignoresSafeArea()
                    .padding(.horizontal)
                    .onAppear() {
                        selectedView = 0
                    }
            }
                .onAppear {
                    // Handle no network condition
                    if !ExploreView.isNetworkAvailable() {
                        webViewModel.intention = "NO_NETWORK"
                    }
                }
                .navigationTitle(localizationManager.localizedString(for: "explore"))
                .toolbar {
                    ToolbarItem(placement: .automatic) {
                        BarContent(isShowingSheet: $isShowingSheet, selectedView: $selectedView)
                    }
                }
        )
    }
}

extension EnvironmentValues {
    var adaptiveSize: CGSize {
        get { self[AdaptiveSizeKey.self] }
        set { self[AdaptiveSizeKey.self] = newValue }
    }
}

private struct AdaptiveSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = UIScreen.main.bounds.size
}

struct BarContent: View {
    @Binding var isShowingSheet: Bool
    @Binding var selectedView: Int?
    
    var body: some View {
        if selectedView == 0 {
            Button {
                isShowingSheet = true
            } label: {
                ProfilePicture()
            }
        }
    }
}

struct ProfilePicture: View {
    var body: some View {
        Image(systemName: "person.circle.fill")
            .resizable()
            .scaledToFit()
            .foregroundColor(.indigo)
            .frame(width: 40, height: 40)
    }
}

extension Font {
    static func customFont(_ name: String, size: CGFloat) -> Font {
        guard let fontURL = Bundle.main.url(forResource: name, withExtension: "ttf") else {
            // Handle if the font file cannot be found
            return Font.system(size: size)
        }
        
        if let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
           let font = CGFont(fontDataProvider) {
            CTFontManagerRegisterGraphicsFont(font, nil)
            return Font.custom(name, size: size)
        } else {
            // Handle if the font file cannot be loaded
            return Font.system(size: size)
        }
    }
}
