import UIKit
import AVFoundation

public enum InstrumentType {
    case Piano
    case Guitar
    case Trumpet
    
    public func getShape() -> Shape {
        switch self {
        case .Piano:
            return Square(color: Color(hue: 240, saturation: 100, value: 100))
        case .Guitar:
            return Triangle(color: Color(hue: 120, saturation: 100, value: 100))
        case .Trumpet:
            return Circle(color: Color(hue: 240, saturation: 100, value: 100))
        }
    }
}

public protocol Instrument {
    func getType() -> InstrumentType
    func getTimbre() -> AVAudioFile?
}

public class InstrumentFactory {
    
    private static var sharedFactory = InstrumentFactory()
    
    public class func shared() -> InstrumentFactory {
        return sharedFactory
    }
    
    public func createInstrument(withType type: InstrumentType) -> Instrument {
        switch type {
        case .Piano:
            return PianoInstrument()
        case .Guitar:
            return GuitarInstrument()
        case .Trumpet:
            return TrumpetInstrument()
        }
    }
}
