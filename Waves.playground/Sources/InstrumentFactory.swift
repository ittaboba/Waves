import UIKit

public enum InstrumentType {
    case Piano
    case Guitar
    case Trumpet
    
    public func getShape() -> Shape {
        switch self {
        case .Piano:
            return Circle(diameter: 120,
                          color: Color(hue: 0, saturation: 100, value: 100))
        case .Guitar:
            return Square(size: CGSize(width: 120, height: 120),
                          color: Color(hue: 120, saturation: 100, value: 100))
        case .Trumpet:
            return Triangle(size: CGSize(width: 120, height: 120),
                            color: Color(hue: 240, saturation: 100, value: 100))
        }
    }
}

public protocol Instrument {
    var shape: Shape {get set}
    
    func getType() -> InstrumentType
}

public class InstrumentFactory {
    
    private static var sharedFactory = InstrumentFactory()
    
    public class func shared() -> InstrumentFactory {
        return sharedFactory
    }
    
    public func createInstrument(withType type: InstrumentType) -> Instrument {
        switch type {
        case .Piano:
            return PianoInstrument(withShape: type.getShape())
        case .Guitar:
            return GuitarInstrument(withShape: type.getShape())
        case .Trumpet:
            return TrumpetInstrument(withShape: type.getShape())
        }
    }
}