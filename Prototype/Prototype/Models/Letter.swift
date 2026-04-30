//
//  Letter.swift
//  Prototype
//
//  Created by Daniel Mercuri on 30/4/2026.
//

import Foundation

struct Letter:Identifiable {
    let id = UUID()
    let letterChar: Character
    let position: CGPoint
}
