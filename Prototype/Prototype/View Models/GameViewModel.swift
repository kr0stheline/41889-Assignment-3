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

    @Published var letters: [Letter] = []
    @Published var words: [String] = []
    @Published var time: Int = 0
    @Published var currentWord: Int = 0
    @Published var score:Double = 0.0
    
    @Published var currentAttempt: [Letter?] = []
    @Published var guessFeedback: GuessFeedback = .none
    @Published var isGameOver: Bool = false
    
    let topic: Topic
    let difficulty: Difficulty
    
    private var timer: Timer?
    private var initialBankOrder: [Letter] = []
    
    var isAttemptComplete: Bool {
        !currentAttempt.contains(where: { $0 == nil })
    }

    var totalStages: Int {
        words.count
    }
    
    var tileSize: CGFloat {
        let count = words[currentWord].count
        switch count {
        case 0...3: return 70
        case 4: return 60
        case 5: return 52
        case 6: return 45
        default: return 38
        }
    }
    
    init(topic: Topic, difficulty: Difficulty) {
        self.topic = topic
        self.difficulty = difficulty
        self.words = GameConfig.wordBank[topic] ?? ["CAT", "DOG"]
        self.time = difficulty.timeLimitSeconds
        populateLetters()
    }

    
    private func tick() {
        guard time > 0 else {
            stopGame()
            nextWord()
            return
        }
        
        time -= 1
    }
    
    private func incrementScore() {
        let safeTime = max(time, 1)
        score += 50.5 * Double(difficulty.timeLimitSeconds) / Double(safeTime) * difficulty.scoreMultiplier
    }
    
    func startGame() {
        guard !isGameOver else { return }
        guard timer == nil else { return }
        
        if time <= 0 {
            time = difficulty.timeLimitSeconds
        }
        // Use .common so the timer keeps firing during scroll gestures; fire on main without extra hop.
        let t = Timer(timeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
        RunLoop.main.add(t, forMode: .common)
        timer = t
    }
    
    func stopGame() {
        timer?.invalidate()
        timer = nil
    }
    
    func populateLetters() {
        var builtLetters: [Letter] = []
        var letterIndex: Int = 0
        for c in words[currentWord] {
            builtLetters.append(Letter(letterChar: c, index: letterIndex))
            letterIndex += 1
        }
        letters = builtLetters
        letters.shuffle()
        initialBankOrder = letters
        resetAttempt()
    }
    
    func nextWord(from expectedWordIndex: Int? = nil) {
        if let expectedWordIndex, expectedWordIndex != currentWord {
            return
        }

        guard !isGameOver else { return }
        guard currentWord + 1 < words.count else {
            // no more words — stop timer and flip the flag
            stopGame()
            isGameOver = true
            return
        }
        currentWord += 1
        letters.removeAll()
        guessFeedback = .none
        populateLetters()
        time = difficulty.timeLimitSeconds
        
        
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
        guard isAttemptComplete else { return }

        if guessFeedback == .correct {
            return
        }

        let attempted = currentAttempt.reduce("") { result, letter in
            result + (letter.map { String($0.letterChar) } ?? "")
        }
        let matches = attempted == words[currentWord]
        guessFeedback = matches ? .correct : .incorrect

        if matches {
            incrementScore()
            
            stopGame()
        } else {
            // On wrong answer, restore bank and clear all slots automatically.
            letters = initialBankOrder
            resetAttempt()
        }
    }
}


