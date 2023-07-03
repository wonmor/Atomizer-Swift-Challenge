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
    
    @State private var lastHostingView: UIView!
    @State private var intention: String = ""
    
    @ObservedObject var articleData = ArticleViewModel()
    @ObservedObject var webViewModel = WebViewModel()
    
    var body: some View {
        
        WebView(urlString: "https://electronvisual.org?fullscreen=true", viewModel: webViewModel)
            .ignoresSafeArea()
            .padding(.horizontal)
            .ignoresSafeArea()
            .onReceive(webViewModel.$intention) { intention in
                DispatchQueue.main.async {
                    self.intention = intention
                }
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
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ExploreView()
        }
        .preferredColorScheme(.light)
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
