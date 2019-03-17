
import AVFoundation

public class GuitarInstrument: Instrument {

    public func getType() -> InstrumentType {
        return .Guitar
    }
    
    public func getTimbre() -> AVAudioFile? {
        if let url = Bundle.main.url(forResource: "pianoC", withExtension: "mp3") {
            let timbre = try! AVAudioFile(forReading: url)
            return timbre
        }
        
        return nil
    }
    
}
