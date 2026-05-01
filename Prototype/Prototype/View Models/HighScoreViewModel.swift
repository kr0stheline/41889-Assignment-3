//
//  HighScoreViewModel.swift
//  Prototype
//
//  Created by LAL, Taras on 30/4/2026.
//
import Foundation
import Combine

struct GameResult: Codable, Identifiable, Equatable {
    let id: UUID
    let playerName: String
    let difficulty: String
    let correctCount: Int
    let score: Int
    let topic: String
    let date: Date
    
    init(playerName: String, difficulty: String, correctCount: Int, score: Int, topic: String) {
        self.id = UUID()
        self.playerName = playerName
        self.difficulty = difficulty
        self.correctCount = correctCount
        self.score = score
        self.topic = topic
        self.date = Date()
    }
}
                        
class HighScoreViewModel: ObservableObject {
    private static let scoresKey = "WordScrambleHighScores"
    
    @Published private(set) var scores: [GameResult] = []
    
    init() {
        load()
    }
    
    func addScore(_ result: GameResult) {
        scores.append(result)
        scores.sort { $0.score > $1.score }
        save()
    }
    
    var topScore: Int? {
        scores.first?.score
    }
    
    private func save() {
        guard let data = try? JSONEncoder().encode(scores) else { return }
        UserDefaults.standard.set(data, forKey: Self.scoresKey)
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.scoresKey),
              let decoded = try? JSONDecoder().decode([GameResult].self, from: data) else { return }
        scores = decoded
    }
}
