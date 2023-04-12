//
//  ExploreView.swift
//  Atomizer
//
//  Created by John Seong on 2023-04-09.
//

import SwiftUI

extension EnvironmentValues {
    var adaptiveSize: CGSize {
        get { self[AdaptiveSizeKey.self] }
        set { self[AdaptiveSizeKey.self] = newValue }
    }
}

private struct AdaptiveSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = UIScreen.main.bounds.size
}

struct ExploreView: View {
    @Environment(\.adaptiveSize) var adaptiveSize
    
    var body: some View {
        LazyVStack {
            Text("This is explore page")
                .padding()
                .navigationTitle("Explore")
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
    }
}
