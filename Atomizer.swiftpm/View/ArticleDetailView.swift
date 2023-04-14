//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-13.
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(article.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(article.subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Divider()
                    Text(article.content)
                        .font(.body)
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .navigationTitle("Article")
    }
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(article: articles[0])
    }
}
