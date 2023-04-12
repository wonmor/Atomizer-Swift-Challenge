//
//  TodayItem.swift
//  App Store
//
//  Created by John Seong on 2023-04-09.
//

import SwiftUI

// Model And Model Data...

struct Article: Identifiable {
    
    var id = UUID().uuidString
    var title: String
    var category: String
    var overlay: String
    var contentImage: String
    var logo: String
}

var items = [

    Article(title: "Forza Street", category: "Ultimate Street Racing Game", overlay: "GAME OF THE DAY", contentImage: "b1", logo: "l1"),
    
    Article(title: "Roblox", category: "Adventure", overlay: "Li Nas X Performs In Roblox", contentImage: "b2", logo: "l2")
]

