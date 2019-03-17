
import AVFoundation

public class PianoInstrument: Instrument {
    public var shape: Shape
    
    init(withShape shape: Shape) {
        self.shape = shape
    }
    
    public func getType() -> InstrumentType {
        return .Piano
    }
    
    public func getTimbre() -> AVAudioFile? {
        if let url = Bundle.main.url(forResource: "pianoC", withExtension: "mp3") {
            let timbre = try! AVAudioFile(forReading: url)
            return timbre
        }
        
        return nil
    }
}
