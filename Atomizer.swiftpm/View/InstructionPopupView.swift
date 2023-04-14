//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-14.
//

import SwiftUI

struct InstructionPopupView: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack {
            VStack {
                Text("Instructions")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
                
                Text("Pan or pinch to rotate and zoom")
                    .padding(.top)
                    .foregroundColor(.black)
                
                Image(systemName: "hand.draw") // Use an appropriate icon for demonstration
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.black)
                
                Text("Long press to freeze")
                    .padding(.top)
                    .foregroundColor(.black)
                
                Image(systemName: "rectangle.compress.vertical") // Use an appropriate icon for demonstration
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.white.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
        .opacity(isVisible ? 1.0 : 0.0)
    }
}
