import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ArticleDetailView: View {
    let article: Article
    let localizationManager = LocalizationManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let image = UIImage(named: article.imageUrl) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .cornerRadius(8)
                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
                        .frame(height: 200)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(article.title)
                        .font(Font.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text(article.subtitle)
                        .font(Font.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    FormattedTextView(text: article.content)
                }
                .padding(.top, 16)
                .padding(.bottom, 32)
                
                // Conditionally display NavigationLink based on article title
                Group {
                    if article.title.lowercased().contains("atom") || article.title.lowercased().contains("atomic") {
                        // For "Explore atoms" button
                        HStack {
                            Spacer()
                            NavigationLink(destination: AtomView()) {
                                Text("View in AR")
                                    .font(Font.system(.title3, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: 200, minHeight: 50)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.white, lineWidth: 2))
                                    .shadow(color: Color(red: 0, green: 0, blue: 139/255).opacity(0.3), radius: 3, x: 0, y: 3)
                                    .padding(.horizontal, 32)
                            }
                            Spacer()
                        }
                    } else if article.title.lowercased().contains("molecule") || article.title.lowercased().contains("molecular") {
                        // For "Explore molecules" button
                        HStack {
                            Spacer()
                            NavigationLink(destination: MoleculeView()) {
                                Text("View in AR")
                                    .font(Font.system(.title3, design: .rounded))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 16)
                                    .frame(maxWidth: 200, minHeight: 50)
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.white, lineWidth: 2))
                                    .shadow(color: Color(red: 0, green: 0, blue: 139/255).opacity(0.3), radius: 3, x: 0, y: 3)
                                    .padding(.horizontal, 32)
                            }
                            Spacer()
                        }
                    }


                }

            }
            .padding()
        }
        .navigationTitle(localizationManager.localizedString(for: "article"))
    }
}
