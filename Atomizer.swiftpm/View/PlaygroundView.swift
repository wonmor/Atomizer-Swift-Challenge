//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-07-03.
//

import SwiftUI

struct PlaygroundView: View {
    @State private var lastHostingView: UIView!
    
    // Required param
    @Binding var isShowingSheet: Bool
    
    // Treated as an optional param
    @ObservedObject var webViewModel = WebViewModel()
    
    var body: some View {
        WebView(urlString: "https://electronvisual.org/playground?fullscreen=true", viewModel: webViewModel)
            .ignoresSafeArea()
            .padding(.horizontal)
            .ignoresSafeArea()
            .navigationTitle(localizationManager.localizedString(for: "playground"))
            .introspectNavigationController { navController in
                let bar = navController.navigationBar
                let hosting = UIHostingController(rootView: BarContent(isShowingSheet: $isShowingSheet))
                
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
