import SwiftUI
import Introspect
import WebKit

/**
 A view that displays an article.
 
 ATOMIZER
 Developed and Designed by John Seong.
 */

struct WebView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlString) else {
            return WKWebView()
        }
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // No updates needed
    }
}

struct ExploreView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    @Environment(\.colorScheme) var colorScheme
    
    @State private var lastHostingView: UIView!
    
    @ObservedObject var articleData = ArticleViewModel()
    
    var body: some View {
        
        WebView(urlString: "https://electronvisual.org?fullscreen=true")
            .ignoresSafeArea()
            .padding(.horizontal)
            .ignoresSafeArea()
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

