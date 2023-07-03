import SwiftUI

struct MemberView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Text("Get Atomizer Tenure")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Become a member to have unlimited access to all content.")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            Button(action: {
                // Implement your payment logic here
            }) {
                Text("Subscribe")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding()
                    .background(Color.indigo)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
    }
}


struct MemberView_Previews: PreviewProvider {
    static var previews: some View {
        MemberView()
    }
}
