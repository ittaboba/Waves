import UIKit
import AVFoundation

public class PianoInstrument: Instrument {
    
    public func getIcon() -> UIImage? {
        return UIImage(named: "PianoIcon.png")
    }
    
    public func getType() -> InstrumentType {
        return .Piano
    }
    
    public func getTimbre() -> AVAudioFile? {
        if let url = Bundle.main.url(forResource: "PianoC1", withExtension: "wav") {
            let timbre = try! AVAudioFile(forReading: url)
            return timbre
        }
        
        return nil
    }
}
