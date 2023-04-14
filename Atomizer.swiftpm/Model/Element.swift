//
//  File.swift
//  
//
//  Created by John Seong on 2023-04-13.
//

import Foundation

struct Element: Codable {
    let symbol: String
    let name: String
    let category: String
    let description: String
    let electronConfiguration: String
    let atomicMass: Double
    let oxidationStates: Int
}
