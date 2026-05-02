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
    @Published var words: [String] = ["CAT", "DOG"]
    @Published var time: Int = 0
    @Published var currentWord: Int = 0
    
    init() {
        populateLetters()
    }
    
    func populateLetters() {
        var letterIndex: Int = 0
        for c in words[currentWord] {
            letters.append(Letter(letterChar: c, index: letterIndex))
            letterIndex += 1
        }
    }
    
    func incrementCurrentWord() {
        currentWord += 1
        letters.removeAll()
        populateLetters()
    }
}


