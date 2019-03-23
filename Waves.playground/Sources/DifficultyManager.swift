public class DifficultyManager {
    private var gameDifficulty: Difficulty?
    
    public init() {}
    
    /**
     Sets a new game with a given difficulty level.
     
     - parameters:
     - level: The difficulty level of the game to be set. This value needs to be an instance of Easy, Medium or Hard classes. According with the level will be performed a different algorithm to set the game.
     
     - returns:
     An array of Notes containing the pitch values to be played
     */
    public func setGame(withDifficultyLevel level: Difficulty) -> [Note] {
        self.gameDifficulty = level
        return self.gameDifficulty!.setGame()
    }
}

