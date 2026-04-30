//
//  GameViewModel.swift
//  Prototype
//
//  Created by Daniel Mercuri on 30/4/2026.
//

import Foundation
import SwiftUI
import Combine


class GameViewModelModel: ObservableObject {
    @Published var letters: [Letter] = []
    @Published var words: [String] = ["Cat", "Dog"]
    @Published var time: Int = 0
}

func populateLetters() {
    for c in words[0] {
        
    }
}
