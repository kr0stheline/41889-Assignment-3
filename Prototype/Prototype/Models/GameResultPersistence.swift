import Foundation

// keeps "append one score + sort" in one file
enum GameResultPersistence {
    static func saveNewResult(
        _ result: GameResult,
        storage: ScoreStorage = UserDefaultsScoreStorage()
    ) throws {
        var scores = try storage.loadScores()
        // already stored this run (e.g. results screen opened twice)
        guard !scores.contains(where: { $0.id == result.id }) else { return }
        scores.append(result)
        scores.sort { $0.score > $1.score }
        try storage.saveScores(scores)
    }
}
