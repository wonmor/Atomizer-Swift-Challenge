import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ContentView: View {
    @State private var selectedView: Int? = 0
    @State private var lastHostingView: UIView!
    
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ExploreView(),
                    tag: 0,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "explore"), systemImage: "eyeglasses")
                    }
                )
                
                NavigationLink(
                    destination: AtomView(),
                    tag: 1,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "atoms"), systemImage: "atom")
                    }
                )
                
                NavigationLink(
                    destination: MoleculeView(),
                    tag: 2,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "molecules"), systemImage: "drop.degreesign")
                    }
                )
                
                Section(header: Text(localizationManager.localizedString(for: "readings"))) {
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction2 : instruction2),
                        tag: 3,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "swift-challenge"), systemImage: "graduationcap")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction3 : instruction3),
                        tag: 4,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "bohr-article-title"), systemImage: "function")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction1 : instruction1),
                        tag: 5,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "homo-and-lumo-title"), systemImage: "figure.2.and.child.holdinghands")
                        }
                    )
                }
            }
            .navigationTitle("Atomizer AR")
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
            
            ZStack {
                if selectedView == 0 {
                    ExploreView()
                } else if selectedView == 1 {
                    AtomView()
                } else if selectedView == 2 {
                    MoleculeView()
                }
            }
        }
    }
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
            .padding(8) // Change this value to add more or less padding
            .frame(width: 40, height: 40)
            .padding(.horizontal)
            .clipShape(Circle())
            .overlay(
                Circle()
                .stroke(Color.blue, lineWidth: 2)
            )
    }
}


