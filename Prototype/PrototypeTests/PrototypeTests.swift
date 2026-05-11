//
//  PrototypeTests.swift
//  PrototypeTests
//
//  Created by DONGWOO WON on 4/30/26.
//

import Testing
@testable import Prototype

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

}
