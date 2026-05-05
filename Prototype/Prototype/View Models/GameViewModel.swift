//
//  GameViewModel.swift
//  Prototype
//
//  Created by Daniel Mercuri on 30/4/2026.
//

import Foundation
import SwiftUI
import Combine


class GameViewModel: ObservableObject {
    
    private static let wordBank: [String: [String]] = [
        "Animals": ["CAT", "DOG", "COW", "BIRD", "FISH", "LION", "FROG", "DUCK"],
        "Fruits": ["APPLE", "GRAPE", "MANGO", "LEMON", "MELON", "PEAR", "KIWI", "PLUM"],
        "Nature": ["TREE", "ROCK", "RIVER", "CLOUD", "LEAF", "MOON", "SUN", "RAIN"],
        "Science": ["ATOM", "CELL", "MAGNET", "ENERGY", "PLANET", "METAL", "LIGHT", "FORCE"]
    ]
    
    @Published var letters: [Letter] = []
    @Published var words: [String] = []
    @Published var time: Int = 0
    @Published var currentWord: Int = 0
    
    @Published var currentAttempt: [Letter?] = []
    @Published var isCorrect: Bool? = nil
    
    let topic: String
    let difficulty: String
    
    private var timer: Timer?
    
    var isAttemptComplete: Bool {
        !currentAttempt.contains(where: { $0 == nil })
    }
    
    init(topic: String, difficulty: String) {
        self.topic = topic
        self.difficulty = difficulty
        self.words = Self.wordBank[topic] ?? ["CAT", "DOG"]
        self.time = Self.timeFor(difficulty:difficulty)
        populateLetters()
    }
    
    private static func timeFor(difficulty: String) -> Int {
        switch difficulty {
        case "Easy": return 45
        case "Medium": return 30
        case "Hard": return 15
        default: return 30
        }
    }
    
    private func tick() {
        guard time > 0 else {
            stopGame()
            return
        }
        
        time -= 1
    }
    
    func startGame() {
        timer?.invalidate()
        
        time = Self.timeFor(difficulty: difficulty)
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in DispatchQueue.main.async {
            self.tick()
        }}
    }
    
    func stopGame() {
        timer?.invalidate()
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
        
        
        startGame()
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
        
        if isCorrect == true {
            stopGame()
        }
    }
}


