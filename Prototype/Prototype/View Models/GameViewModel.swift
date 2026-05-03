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
    
    @Published var currentAttempt: [Letter?] = []
    @Published var isCorrect: Bool? = nil
    
    var isAttemptComplete: Bool {
        !currentAttempt.contains(where: { $0 == nil })
    }
    
    init() {
        populateLetters()
    }
    
    func populateLetters() {
        var letterIndex: Int = 0
        for c in words[currentWord] {
            letters.append(Letter(letterChar: c, index: letterIndex))
            letterIndex += 1
        }
        letters.shuffle()
        resetAttempt()
    }
    
    func nextWord() {
        guard currentWord + 1 < words.count else {
            //game over - handle later
            return
        }
        currentWord += 1
        letters.removeAll()
        isCorrect = nil
        populateLetters()
    }
    
    func resetAttempt() {
        currentAttempt = Array(repeating: nil, count: words[currentWord].count)
    }
    
    func tapLetterFromBank(_ letter: Letter) {
        guard let firstEmpty = currentAttempt.firstIndex(where: { $0 == nil }) else { return }
        currentAttempt[firstEmpty] = letter
        letters.removeAll { $0.id == letter.id }
    }
    
    func tapSlot(at index: Int) {
        guard let letter = currentAttempt[index] else { return }
        currentAttempt[index] = nil
        letters.append(letter)
    }
    
    func confirmAttempt() {
        let attempted = currentAttempt.reduce("") { result, letter in
            result + (letter.map { String($0.letterChar) } ?? "")
        }
        isCorrect = attempted == words[currentWord]
    }
}


