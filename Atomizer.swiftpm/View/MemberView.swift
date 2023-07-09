import SwiftUI
import AVKit

struct MemberView: View {
    @Binding var isPlaying: Bool
    
    @ObservedObject var storeManager = StoreManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer()
                    
                    Text("Get AR Tenure")
                        .font(Font.system(size: 32, weight: .bold, design: .rounded))
                        .fontWeight(.bold)
                    
                    
                    Text("Become a member to have unlimited access to all content.")
                        .font(Font.system(.headline, design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    if let videoURL = Bundle.main.url(forResource: "promo", withExtension: "mp4") {
                        PlayerView(videoURL: videoURL, isPlaying: $isPlaying)
                            .frame(width: geometry.size.width, height: geometry.size.width * 9/16) // Set height based on width and aspect ratio
                        
                    } else {
                        Text("Video not found")
                    }
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if let productToBuy = storeManager.getProducts().first(where: { $0.productIdentifier == "monthly" }) {
                                StoreManager.shared.buyProduct(productToBuy)
                            }
                            
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.indigo, lineWidth: 2)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    VStack(spacing: 10) {
                                        Text("$20")
                                            .foregroundColor(.indigo)
                                            .font(Font.system(size: 32, weight: .bold, design: .rounded))
                                        
                                        Text("every month")
                                            .foregroundColor(.indigo)
                                            .font(Font.system(size: 18, weight: .bold, design: .rounded))
                                    }
                                )
                        }
                        
                        Button(action: {
                            // Assuming you have obtained the available products in the response
                            if let productToBuy = storeManager.getProducts().first(where: { $0.productIdentifier == "yearly" }) {
                                StoreManager.shared.buyProduct(productToBuy)
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                                .frame(width: 150, height: 150)
                                .overlay(
                                    VStack(spacing: 10) {
                                        Text("$40")
                                            .foregroundColor(.blue)
                                            .font(Font.system(size: 32, weight: .bold, design: .rounded))
                                        
                                        Text("every year")
                                            .foregroundColor(.blue)
                                            .font(Font.system(size: 18, weight: .bold, design: .rounded))
                                    }
                                )
                        }
                        
                        
                    }
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    
                    VStack(spacing: 10) {
                        Button(action: {
                            StoreManager.shared.restorePurchases()
                        }) {
                            Text("Restore Purchases")
                                .foregroundColor(.white)
                                .font(Font.system(size: 16, weight: .bold, design: .rounded))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 20)
                                .background(Color.indigo)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding(.vertical)
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .background(.black)
        }
    }
}

struct PlayerView: UIViewControllerRepresentable {
    var videoURL: URL
    @Binding var isPlaying: Bool
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        player.isMuted = false
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        if isPlaying {
            uiViewController.player?.play()
        } else {
            uiViewController.player?.pause()
        }
    }
}
