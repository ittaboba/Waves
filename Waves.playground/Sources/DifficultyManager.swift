public class DifficultyManager {
    private var gameDifficulty: Difficulty?
    
    public init() {}
    
    public func setGame(withDifficultyLevel level: Difficulty) -> [Note] {
        self.gameDifficulty = level
        return self.gameDifficulty!.setGame()
    }
}

