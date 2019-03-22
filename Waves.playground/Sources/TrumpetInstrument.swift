import UIKit
import AVFoundation

public class TrumpetInstrument: Instrument {
    
    public func getIcon() -> UIImage? {
        return UIImage(named: "TrumpetIcon.png")
    }
    
    public func getType() -> InstrumentType {
        return .Trumpet
    }

    public func getTimbre() -> AVAudioFile? {
        if let url = Bundle.main.url(forResource: "TrumpetC1", withExtension: "wav") {
            let timbre = try! AVAudioFile(forReading: url)
            return timbre
        }
        
        return nil
    }
}
