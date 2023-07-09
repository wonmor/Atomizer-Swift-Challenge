import SwiftUI

/**
    A view that displays an article.
 
    ATOMIZER
    Developed and Designed by John Seong.
*/

struct ContentView: View {
    @State private var selectedView: Int? = 0
    @State private var isShowingSheet = false
    
    let localizationManager = LocalizationManager.shared
    
    init() {
        var titleFont = UIFont.preferredFont(forTextStyle: .largeTitle) /// the default large title font
        titleFont = UIFont(
            descriptor:
                titleFont.fontDescriptor
                .withDesign(.rounded)? /// make rounded
                .withSymbolicTraits(.traitBold) /// make bold
            ??
            titleFont.fontDescriptor, /// return the normal title if customization failed
            size: titleFont.pointSize
        )
        
        /// set the rounded font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: titleFont]
    }
    
    var body: some View {
        NavigationView {
            List {
                NavigationLink(
                    destination: ExploreView(selectedView: $selectedView, isShowingSheet: $isShowingSheet),
                    tag: 0,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "explore"), systemImage: "eyeglasses")
                    }
                )
                
                NavigationLink(
                    destination: AtomView(isShowingSheet: $isShowingSheet),
                    tag: 1,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "atoms"), systemImage: "atom")
                    }
                )
                
                NavigationLink(
                    destination: MoleculeView(isShowingSheet: $isShowingSheet),
                    tag: 2,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "molecules"), systemImage: "drop.degreesign")
                    }
                )
                
                NavigationLink(
                    destination: PlaygroundView(),
                    tag: 3,
                    selection: $selectedView,
                    label: {
                        Label(localizationManager.localizedString(for: "playground"), systemImage: "hammer")
                    }
                )
                
                Section(header: Text(localizationManager.localizedString(for: "readings"))) {
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction2 : instruction2),
                        tag: 4,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "swift-challenge"), systemImage: "graduationcap")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction3 : instruction3),
                        tag: 5,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "bohr-article-title"), systemImage: "function")
                        }
                    )
                    
                    NavigationLink(
                        destination: ArticleDetailView(article: localizationManager.getCurrentLocale().starts(with: "ko") ? koInstruction1 : instruction1),
                        tag: 6,
                        selection: $selectedView,
                        label: {
                            Label(localizationManager.localizedString(for: "homo-and-lumo-title"), systemImage: "point.3.connected.trianglepath.dotted")
                        }
                    )
                }
            }
            .navigationTitle("Atomizer AR")
            .sheet(isPresented: $isShowingSheet) {
                VStack {
                    HStack {
                        Button(action: {
                            isShowingSheet = false
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.primary)
                            Text("Back")
                                .foregroundColor(.primary)
                                .font(Font.system(.headline, design: .rounded))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    MemberView(isPlaying: $isShowingSheet)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .background(.white)
                       .overlay(
                           HStack(spacing: 10) {
                               Image(systemName: "arrow.down.circle")
                                   .font(Font.system(size: 20))
                                   .foregroundStyle(.black)
                               
                               Text("Scroll Down")
                                   .font(Font.system(.headline, design: .rounded))
                                   .foregroundStyle(.black)
                           }
                       )
                       .frame(height: 40)
                }
            }
            
            ZStack {
                if selectedView == 0 {
                    ExploreView(selectedView: $selectedView, isShowingSheet: $isShowingSheet)
                } else if selectedView == 1 {
                    AtomView(isShowingSheet: $isShowingSheet)
                } else if selectedView == 2 {
                    MoleculeView(isShowingSheet: $isShowingSheet)
                } else if selectedView == 3 {
                    PlaygroundView()
                }
            }
        }
        .environment(\.font, Font.system(.body, design: .rounded))
        .tint(.indigo)
    }
}
