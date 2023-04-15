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
                .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
            Text(String(format: "%.2f", element.atomicMass))
                .font(.title)
                .foregroundColor(Color(AtomView.hexStringToUIColor(hex: element.color)))
                .padding(.bottom)
            Text(element.description)
                .padding(.horizontal)
            Spacer()
        }
        .navigationBarTitle(element.name)
    }
}
