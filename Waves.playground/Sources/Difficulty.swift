import Foundation

public enum DifficultyLevel: String {
    case Easy = "Easy"
    case Medium = "Medium"
    case Hard = "Hard"
    
    public static var levels: [DifficultyLevel] {
        return [.Easy, .Medium, .Hard]
    }
}

public protocol Difficulty {
    func setGame() -> [Note]
}


