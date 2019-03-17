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

extension Difficulty {
    public func randomIndexForRange(range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
