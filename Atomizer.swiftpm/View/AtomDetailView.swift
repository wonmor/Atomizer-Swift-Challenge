//
//  SwiftUIView.swift
//  
//
//  Created by John Seong on 2023-04-13.
//

import SwiftUI

struct AtomDetailView: View {
    let element: Element
    
    var body: some View {
        VStack {
            Text(element.symbol)
                .font(.system(size: 96, weight: .bold))
            Text("\(element.atomicMass)")
                .font(.title)
                .padding(.bottom)
            Text(element.description)
                .padding(.horizontal)
            Spacer()
        }
        .navigationBarTitle(element.name)
    }
}
