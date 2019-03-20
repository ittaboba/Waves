import UIKit
import AVFoundation

public enum InstrumentType {
    case Piano
    case Guitar
    case Trumpet
    
    public func getShape() -> Shape {
        let shape = Settings.shared().getShape(forInstrument: self)
        
        if shape is Circle {
            return Circle(color: shape.getColor())
        } else if shape is Square {
            return Square(color: shape.getColor())
        } else {
            return Triangle(color: shape.getColor())
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
