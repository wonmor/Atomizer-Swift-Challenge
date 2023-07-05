//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-07-03.
//

import SwiftUI

struct PlaygroundView: View {
    @State private var lastHostingView: UIView!
    
    // Treated as an optional param
    @ObservedObject var webViewModel = WebViewModel()
    
    var body: some View {
        Group {
            if ExploreView.isNetworkAvailable() {
                WebView(urlString: "https://electronvisual.org/playground?fullscreen=true", viewModel: webViewModel)
                    .ignoresSafeArea()
                    .padding(.horizontal)
                    .ignoresSafeArea()
                    .navigationTitle(localizationManager.localizedString(for: "playground"))
                
            } else {
                NoNetworkView()
            }
        }
    }
}
