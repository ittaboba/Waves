import UIKit

public class GameViewController: UIViewController {
        
    private var levelNotes = [Note]()
    
    private var allTones = [Tone]()
    
    public init(withLevel level: DifficultyLevel, instrumentType: InstrumentType) {
        let gameDifficulty = DifficultyManager()
        var allNotes = [Note]()
        
        switch level {
        case .Easy:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Easy())
            allNotes = Pitch.shared.getNotes(forOctaves: .one)
            
        case .Medium:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Medium())
            
            allNotes = Pitch.shared.getNotes(forOctaves: .two)
        case .Hard:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Hard())
            
            allNotes = Pitch.shared.getNotes(forOctaves: .four)
        }
        
        // create tones for notes
        for i in 0 ..< allNotes.count {
            let instrument = InstrumentFactory.shared().createInstrument(withType: instrumentType)
            
            let tone = Tone(withFrame: CGRect(x: 100 * i, y: 100, width: 300, height: 300),
                            note: allNotes[i],
                            instrument: instrument)
            self.allTones.append(tone)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func loadView() {
        self.view = UIView(frame: CGRect(x: SharedValues.shared.getGameView().getX(),
                                         y: SharedValues.shared.getGameView().getY(),
                                         width: SharedValues.shared.getGameView().getWidth(),
                                         height: SharedValues.shared.getGameView().getHeight()))
        self.view.backgroundColor = SharedValues.shared.getGameView().getBackgroundColor()
        
        // add tones to the view
        for tone in allTones {
            self.view.addSubview(tone)
        }
    }
    
}
