//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-13.
//

import SwiftUI

struct ArticleCardView: View {
    let article: Article
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(article.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .cornerRadius(8)
            Text(article.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundColor(colorScheme == .dark ? .white : .primary)
            Text(article.subtitle)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .foregroundColor(colorScheme == .dark ? .white : .secondary)
            Spacer()
        }
        .padding()
        .background(colorScheme == .dark ? Color(.darkGray) : Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
