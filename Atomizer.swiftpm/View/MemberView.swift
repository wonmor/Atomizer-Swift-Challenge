import SwiftUI
import AVFoundation

struct MemberView: View {
    @State private var audioPlayer: AVAudioPlayer?
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Get Atomizer Tenure")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Become a member to have unlimited access to all content.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()
            
            Button(action: {
                // Implement your payment logic here
                playAudio()
            }) {
                Text("Subscribe")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            playAudio()
        }
        .onDisappear {
            stopAudio()
        }
    }
    
    func playAudio() {
        guard let url = Bundle.main.url(forResource: "narration", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Failed to play audio: \(error.localizedDescription)")
        }
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView()
    }
}
