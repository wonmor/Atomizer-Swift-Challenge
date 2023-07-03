import SwiftUI

struct MemberView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Unlock Premium Content")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Become a member to access exclusive content and features.")
                .font(.body)
                .multilineTextAlignment(.center)
            
            Button(action: {
                // Implement your payment logic here
            }) {
                Text("Subscribe")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView()
    }
}
