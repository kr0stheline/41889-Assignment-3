//
//  HighScoreViewModel.swift
//  Prototype
//
//  Created by LAL, Taras on 30/4/2026.
//
import Foundation
import Combine

enum HighScoreStorageError: LocalizedError {
    case failedToDecode
    case failedToEncode

    var errorDescription: String? {
        switch self {
        case .failedToDecode:
            return "Could not read saved scores."
        case .failedToEncode:
            return "Could not save scores."
        }
    }
}

protocol ScoreStorage {
    func loadScores() throws -> [GameResult]
    func saveScores(_ scores: [GameResult]) throws
}

struct UserDefaultsScoreStorage: ScoreStorage {
    let userDefaults: UserDefaults
    let scoresKey: String

    init(
        userDefaults: UserDefaults = .standard,
        scoresKey: String = HighScoreViewModel.scoresKey
    ) {
        self.userDefaults = userDefaults
        self.scoresKey = scoresKey
    }

    func loadScores() throws -> [GameResult] {
        guard let data = userDefaults.data(forKey: scoresKey) else {
            return []
        }

        guard let decoded = try? JSONDecoder().decode([GameResult].self, from: data) else {
            throw HighScoreStorageError.failedToDecode
        }

        return decoded.sorted { $0.score > $1.score }
    }

    func saveScores(_ scores: [GameResult]) throws {
        guard let data = try? JSONEncoder().encode(scores) else {
            throw HighScoreStorageError.failedToEncode
        }
        userDefaults.set(data, forKey: scoresKey)
    }
}

struct GameResult: Codable, Identifiable, Equatable {
    let id: UUID
    let playerName: String
    let difficulty: Difficulty
    let correctCount: Int
    let score: Int
    let topic: Topic
    let date: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case playerName
        case difficulty
        case correctCount
        case score
        case topic
        case date
    }

    init(
        id: UUID = UUID(),
        playerName: String,
        difficulty: Difficulty,
        correctCount: Int,
        score: Int,
        topic: Topic,
        date: Date = Date()
    ) {
        self.id = id
        self.playerName = playerName
        self.difficulty = difficulty
        self.correctCount = correctCount
        self.score = score
        self.topic = topic
        self.date = date
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        playerName = try container.decode(String.self, forKey: .playerName)
        correctCount = try container.decode(Int.self, forKey: .correctCount)
        score = try container.decode(Int.self, forKey: .score)
        date = (try? container.decode(Date.self, forKey: .date)) ?? Date()

        if let topicValue = try? container.decode(Topic.self, forKey: .topic) {
            topic = topicValue
        } else {
            let topicString = (try? container.decode(String.self, forKey: .topic)) ?? Topic.animals.rawValue
            topic = Topic(rawValue: topicString) ?? .animals
        }

        if let difficultyValue = try? container.decode(Difficulty.self, forKey: .difficulty) {
            difficulty = difficultyValue
        } else {
            let difficultyString = (try? container.decode(String.self, forKey: .difficulty)) ?? Difficulty.medium.rawValue
            difficulty = Difficulty(rawValue: difficultyString) ?? .medium
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(playerName, forKey: .playerName)
        try container.encode(difficulty, forKey: .difficulty)
        try container.encode(correctCount, forKey: .correctCount)
        try container.encode(score, forKey: .score)
        try container.encode(topic, forKey: .topic)
        try container.encode(date, forKey: .date)
    }
}
                        
class HighScoreViewModel: ObservableObject {
    static let scoresKey = "WordScrambleHighScores"
    static let currentPlayerNameKey = "WordScrambleCurrentPlayerName"
    
    @Published private(set) var scores: [GameResult] = []
    @Published private(set) var storageErrorMessage: String?

    private let storage: ScoreStorage

    init(storage: ScoreStorage = UserDefaultsScoreStorage()) {
        self.storage = storage
        load()
    }
    
    func addScore(_ result: GameResult) {
        guard !scores.contains(where: { $0.id == result.id }) else { return }
        scores.append(result)
        scores.sort { $0.score > $1.score }
        save()
    }
    
    var topScore: Int? {
        scores.first?.score
    }
    
    private func save() {
        do {
            try storage.saveScores(scores)
            storageErrorMessage = nil
        } catch {
            storageErrorMessage = error.localizedDescription
        }
    }
    
    private func load() {
        do {
            scores = try storage.loadScores()
            storageErrorMessage = nil
        } catch {
            scores = []
            storageErrorMessage = error.localizedDescription
        }
    }

    static func loadStoredScores(storage: ScoreStorage = UserDefaultsScoreStorage()) -> [GameResult] {
        (try? storage.loadScores()) ?? []
    }

    static func saveStoredScores(
        _ scores: [GameResult],
        storage: ScoreStorage = UserDefaultsScoreStorage()
    ) {
        try? storage.saveScores(scores)
    }

    static func addScore(
        resultID: UUID = UUID(),
        playerName: String,
        difficulty: Difficulty,
        correctCount: Int,
        score: Int,
        topic: Topic,
        storage: ScoreStorage = UserDefaultsScoreStorage()
    ) {
        let trimmedName = playerName.trimmingCharacters(in: .whitespacesAndNewlines)
        let safeName = trimmedName.isEmpty ? "Player" : trimmedName

        var existingScores = loadStoredScores(storage: storage)
        guard !existingScores.contains(where: { $0.id == resultID }) else { return }
        let result = GameResult(
            id: resultID,
            playerName: safeName,
            difficulty: difficulty,
            correctCount: correctCount,
            score: score,
            topic: topic
        )

        existingScores.append(result)
        existingScores.sort { $0.score > $1.score }
        saveStoredScores(existingScores, storage: storage)
    }
}
