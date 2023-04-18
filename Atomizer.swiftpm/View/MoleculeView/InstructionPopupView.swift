//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-14.
//

import SwiftUI

struct InstructionPopupView: View {
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Text("Instructions")
                        .padding()
                        .font(.title)
                    
                    Text("Pan or pinch to rotate and zoom")
                        .padding(.horizontal)
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Image(systemName: "hand.draw") // Use an appropriate icon for demonstration
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundColor(.white)
                    
                    Text("Long press to freeze")
                        .padding(.top)
                        .padding(.horizontal)
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Image(systemName: "rectangle.compress.vertical") // Use an appropriate icon for demonstration
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
        .animation(.easeInOut(duration: 0.5)) // Apply the animation to the ZStack
    }
}
