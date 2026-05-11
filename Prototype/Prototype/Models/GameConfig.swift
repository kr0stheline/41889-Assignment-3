import Foundation

enum Topic: String, CaseIterable, Codable, Identifiable {
    case animals = "Animals"
    case fruits = "Fruits"
    case nature = "Nature"
    case science = "Science"

    var id: String { rawValue }

    var iconSystemName: String {
        switch self {
        case .animals: return "pawprint.fill"
        case .fruits: return "apple.logo"
        case .nature: return "leaf.fill"
        case .science: return "atom"
        }
    }

    var settingsImageName: String {
        switch self {
        case .animals: return "btnAnimals"
        case .fruits: return "btnFruits"
        case .nature: return "btnNature"
        case .science: return "btnScience"
        }
    }
}

enum Difficulty: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"

    var id: String { rawValue }

    var timeLimitSeconds: Int {
        switch self {
        case .easy: return 45
        case .medium: return 30
        case .hard: return 15
        }
    }

    var scoreMultiplier: Double {
        switch self {
        case .easy: return 1.0
        case .medium: return 1.5
        case .hard: return 3.0
        }
    }

    var settingsImageName: String {
        switch self {
        case .easy: return "btnEasy"
        case .medium: return "btnMedium"
        case .hard: return "btnHard"
        }
    }
}

enum GameConfig {
    static let wordBank: [Topic: [String]] = [
        .animals: ["CAT", "DOG", "COW", "BIRD", "FISH", "LION", "FROG", "DUCK"],
        .fruits: ["APPLE", "GRAPE", "MANGO", "LEMON", "MELON", "PEAR", "KIWI", "PLUM"],
        .nature: ["TREE", "ROCK", "RIVER", "CLOUD", "LEAF", "MOON", "SUN", "RAIN"],
        .science: ["DNA", "ATOM", "CELL", "MAGNET", "ENERGY", "PLANET", "METAL", "LIGHT"]
    ]
}
