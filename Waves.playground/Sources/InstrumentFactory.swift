import UIKit
import AVFoundation

public enum InstrumentType: String {
    case Piano = "Piano"
    case Guitar = "Guitar"
    case Trumpet = "Trumpet"
    
    /**
     - returns:
     The shape associated to the instrument
     */
    public func getShape(withSize size: CGSize) -> Shape {
        let shape = Settings.shared().getShape(forInstrument: self)
        
        if shape is Circle {
            return Circle(color: shape.getColor(), size: size)
        } else if shape is Square {
            return Square(color: shape.getColor(), size: size)
        } else {
            return Triangle(color: shape.getColor(), size: size)
        }
    }
}

public protocol Instrument {
    /**
     - returns:
     The icon associated with the instrument
     */
    func getIcon() -> UIImage?
    
    /**
     - returns:
     An enum value containing the instrument type
    */
    func getType() -> InstrumentType
    
    /**
     - returns:
     The audio file containing the sample tone of the instrument. It refers to C1 tone and can be changed by applying a time pitch effect to produce different tones
     */
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
