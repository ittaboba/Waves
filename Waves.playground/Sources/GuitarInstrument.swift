
import AVFoundation

public class GuitarInstrument: Instrument {

    public func getType() -> InstrumentType {
        return .Guitar
    }
    
    public func getTimbre() -> AVAudioFile? {
        if let url = Bundle.main.url(forResource: "GuitarC1", withExtension: "wav") {
            let timbre = try! AVAudioFile(forReading: url)
            return timbre
        }
        
        return nil
    }
    
}
