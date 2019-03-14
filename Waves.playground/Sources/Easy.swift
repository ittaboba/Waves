
public class Easy: Difficulty {
    
    private var notes: [Note]
    
    public init() {
        self.notes = [Note]()
    }
    
    public func setGame() -> [Note] {
        let notes = Pitch.shared.getNotes(forOctaves: .one)
        return notes
    }
    
}

