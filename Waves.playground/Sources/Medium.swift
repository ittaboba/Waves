
public class Medium: Difficulty {
    
    public init() {}
    
    public func setGame() -> [Note] {
        let notes = Pitch.shared.getNotes(forOctaves: .two)
        
        var gameNotes = [Note]()
        
        for _ in 0 ..< 7 {
            let randomIndex = self.randomIndexForRange(range: 0 ..< notes.count)
            let randomNote = notes[randomIndex]
            gameNotes.append(randomNote)
        }
        
        return gameNotes
    }
}

