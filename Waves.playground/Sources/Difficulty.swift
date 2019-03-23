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
    /**
     Provides a random index within the given range.
     Use this method to generate random sound pitch.
     
     - parameters:
     - range: The interval of valid random index
     
     - returns:
     A random integer value within the range
     */
    public func randomIndexForRange(range: Range<Int>) -> Int {
        return range.lowerBound + Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)))
    }
}
