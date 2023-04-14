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

let articles = [
    Article(
        title: "Article 1",
        subtitle: "Subtitle 1",
        imageName: "article1",
        content: "This is the content for article 1."
    ),
    Article(
        title: "Article 2",
        subtitle: "Subtitle 2",
        imageName: "article2",
        content: "This is the content for article 2."
    ),
    Article(
        title: "Article 3",
        subtitle: "Subtitle 3",
        imageName: "article3",
        content: "This is the content for article 3."
    ),
    Article(
        title: "Article 4",
        subtitle: "Subtitle 4",
        imageName: "article4",
        content: "This is the content for article 4."
    ),
    Article(
        title: "Article 5",
        subtitle: "Subtitle 5",
        imageName: "article5",
        content: "This is the content for article 5."
    ),
    Article(
        title: "Article 6",
        subtitle: "Subtitle 6",
        imageName: "article6",
        content: "This is the content for article 6."
    )
]
