import UIKit
import AVFoundation

public class Tone: UIView {
    
    private var note: Note?
    private var instrument: Instrument
    private var engine: AVAudioEngine
    
    private var audioPlayer: TonePlayer?
    
    public init(withInstrument instrument: Instrument, note: Note?, engine: AVAudioEngine) {
        self.note = note
        self.instrument = instrument
        self.engine = engine
        
        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        super.init(frame: frame)
        
        // set Tone shape
        let toneShape = instrument.getType().getShape(withSize: CGSize(width: 50, height: 50))
        self.layer.mask = toneShape
        
        // set Tone color based on Note
        if let n = note {
            let instrumentHue = toneShape.getColor().getHue()
            
            let allNotes = Pitch.shared.getNotes(forOctaves: .two)
            
            if let index = allNotes.firstIndex(of: n) {
                let octave = CGFloat(index/7 + 1)
                let octaveNote = CGFloat(index % 7)
                
                let saturation = CGFloat(100 - octave * 20)
                let value = CGFloat(100 - octaveNote * 10)
                
                let toneColor = Color(hue: instrumentHue, saturation: saturation, value: value)
                
                self.backgroundColor = toneColor.toRGBColor()
            }
        } else {
            let placeholderColor = Color(hue: 0, saturation: 0, value: 80)
            self.backgroundColor = placeholderColor.toRGBColor()
        }
        
        // set audioPlayer
        if let n = note {
            self.audioPlayer = TonePlayer(withEngine: engine, instrument: instrument, note: n)
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getNote() -> Note? {
        return self.note
    }

    public func isPlaceholder() -> Bool {
        if let _ = self.note {
            return false
        }
        
        return true
    }
    
    public func clone() -> Tone {
        return Tone(withInstrument: self.instrument, note: self.note, engine: self.engine)
    }
    
    public func play(didFinish: (() -> Void)?) {        
        if let player = self.audioPlayer {
            player.play(didFinish: {
                didFinish?()
            })
        } else {
            // silence
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2, execute: {
                didFinish?()
            })
        }
    }
    
    public func stop() {
        if let player = self.audioPlayer {
            player.stop()
        }
    }
}
