import SwiftUI
import AVKit

struct MemberView: View {
    @Binding var isPlaying: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Text("Get AR Tenure")
                    .font(Font.system(.largeTitle, design: .rounded))
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
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.indigo, lineWidth: 2)
                        .frame(width: 150, height: 50)
                        .overlay(
                            Text("$20\nevery month")
                                .foregroundColor(.indigo)
                                .font(Font.system(.headline, design: .rounded))
                        )
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue, lineWidth: 2)
                        .frame(width: 150, height: 50)
                        .overlay(
                            Text("$40\nevery year")
                                .foregroundColor(.blue)
                                .font(Font.system(.headline, design: .rounded))
                        )
                }
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
                
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.all)
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
