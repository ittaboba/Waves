
import AVFoundation

public class PianoInstrument: Instrument {
    
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
