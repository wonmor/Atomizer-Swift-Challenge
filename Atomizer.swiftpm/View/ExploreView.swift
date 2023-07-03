import SwiftUI
import Introspect
import WebKit

/**
 A view that displays an article.
 
 ATOMIZER
 Developed and Designed by John Seong.
 */

struct ExploreView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var selectedView: Int?
    
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
                        // The force unwrapped value below should later be handled with error message, as there might be more molecules added to the website but not necessarily reflected back on the app on time.
                        MoleculeDetailView(molecule: loadMolecule(formula: formula)!)
                        // Do NOT change selectedView variable here. It will break the code.
                    }
                    
                case let type as String where type == "atom":
                    if let formula = webViewModel.metadata?["formula"] as? String {
                        AtomDetailView(element: loadElement(formula: formula)!)
                        // Do NOT change selectedView variable here. It will break the code.
                    }
                    
                default:
                    webViewWrapper()
                }
            }
           
        case "OPEN_ATOM_PAGE":
            AtomView()
                .onAppear() {
                    selectedView = 1
                }
        
        case "OPEN_MOLECULE_PAGE":
            MoleculeView()
                .onAppear() {
                    selectedView = 2
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
    
    func webViewWrapper() -> some View {
        return (
            WebView(urlString: "https://electronvisual.org?fullscreen=true", viewModel: webViewModel)
                .ignoresSafeArea()
                .padding(.horizontal)
                .ignoresSafeArea()
                .onAppear() {
                    selectedView = 0;
                }
                .navigationTitle(localizationManager.localizedString(for: "explore"))
                .introspectNavigationController { navController in
                    let bar = navController.navigationBar
                    let hosting = UIHostingController(rootView: BarContent())
                    
                    guard let hostingView = hosting.view else { return }
                    // bar.addSubview(hostingView)                                          // <--- OPTION 1
                    // bar.subviews.first(where: \.clipsToBounds)?.addSubview(hostingView)  // <--- OPTION 2
                    hostingView.backgroundColor = .clear
                    
                    lastHostingView?.removeFromSuperview()
                    bar.addSubview(hostingView) // Add the hostingView as a subview first
                    lastHostingView = hostingView
                    
                    hostingView.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        hostingView.trailingAnchor.constraint(equalTo: bar.trailingAnchor),
                        hostingView.bottomAnchor.constraint(equalTo: bar.bottomAnchor, constant: -8)
                    ])
                    
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
    var body: some View {
        Button {
            print("Profile tapped")
        } label: {
            ProfilePicture()
        }
    }
}

struct ProfilePicture: View {
    var body: some View {
        Image(systemName: "person")
            .resizable()
            .scaledToFit()
            .foregroundColor(.indigo)
            .padding(8) // Change this value to add more or less padding
            .frame(width: 40, height: 40)
            .padding(.horizontal)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.indigo, lineWidth: 2)
            )
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
