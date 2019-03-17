import UIKit
import AVFoundation

public enum InstrumentType {
    case Piano
    case Guitar
    case Trumpet
    
    public func getShape(withSize size: CGSize) -> Shape {
        switch self {
        case .Piano:
            return Circle(diameter: size.width,
                          color: Color(hue: 0, saturation: 100, value: 100))
        case .Guitar:
            return Square(size: size,
                          color: Color(hue: 120, saturation: 100, value: 100))
        case .Trumpet:
            return Triangle(size: size,
                            color: Color(hue: 240, saturation: 100, value: 100))
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
