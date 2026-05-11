//
//  PrototypeTests.swift
//  PrototypeTests
//
//  Created by DONGWOO WON on 4/30/26.
//

import Testing
import Foundation
@testable import Prototype

private final class SharedInMemoryScoreStorage: ScoreStorage {
    var scores: [GameResult] = []

    func loadScores() throws -> [GameResult] {
        scores
    }

    func saveScores(_ scores: [GameResult]) throws {
        self.scores = scores
    }
}

struct PrototypeTests {

    @Test func difficultyConfigValuesAreStable() async throws {
        #expect(Difficulty.easy.timeLimitSeconds == 45)
        #expect(Difficulty.medium.timeLimitSeconds == 30)
        #expect(Difficulty.hard.timeLimitSeconds == 15)
    }

    @Test func allTopicsHaveWordsConfigured() async throws {
        for topic in Topic.allCases {
            let words = GameConfig.wordBank[topic] ?? []
            #expect(!words.isEmpty)
        }
    }

    @Test func correctAttemptStopsTimerAndMarksCorrect() async throws {
        let viewModel = GameViewModel(topic: .animals, difficulty: .easy)
        let targetWord = viewModel.words[viewModel.currentWord]

        for character in targetWord {
            guard let nextLetter = viewModel.letters.first(where: { $0.letterChar == character }) else {
                Issue.record("Expected letter \(character) in bank")
                return
            }
            viewModel.tapLetterFromBank(nextLetter)
        }

        viewModel.confirmAttempt()

        #expect(viewModel.isCorrect == true)
        #expect(viewModel.score > 0)
    }

    @Test func nextWordIgnoresStaleExpectedIndex() async throws {
        let viewModel = GameViewModel(topic: .animals, difficulty: .easy)
        let originalWord = viewModel.currentWord

        viewModel.nextWord(from: originalWord)
        viewModel.nextWord(from: originalWord)

        #expect(viewModel.currentWord == originalWord + 1)
    }

    @Test func confirmAttemptDoesNotDoubleIncrementScore() async throws {
        let viewModel = GameViewModel(topic: .animals, difficulty: .easy)
        let targetWord = viewModel.words[viewModel.currentWord]

        for character in targetWord {
            guard let nextLetter = viewModel.letters.first(where: { $0.letterChar == character }) else {
                Issue.record("Expected letter \(character) in bank")
                return
            }
            viewModel.tapLetterFromBank(nextLetter)
        }

        viewModel.confirmAttempt()
        let firstScore = viewModel.score
        viewModel.confirmAttempt()

        #expect(viewModel.score == firstScore)
    }

    @Test func addScoreIsIdempotentForSameResultID() async throws {
        let storage = SharedInMemoryScoreStorage()
        let sameResultID = UUID()

        try HighScoreViewModel.addScore(
            resultID: sameResultID,
            playerName: "Kris",
            difficulty: .medium,
            correctCount: 4,
            score: 100,
            topic: .animals,
            storage: storage
        )

        try HighScoreViewModel.addScore(
            resultID: sameResultID,
            playerName: "Kris",
            difficulty: .medium,
            correctCount: 4,
            score: 100,
            topic: .animals,
            storage: storage
        )

        let scores = HighScoreViewModel.loadStoredScores(storage: storage)
        #expect(scores.count == 1)
    }

}
