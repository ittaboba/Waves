import UIKit

public enum InstrumentType {
    case Piano
    case Guitar
    
    public func getShape() -> Shape {
        switch self {
        case .Piano:
            return Circle(diameter: 120, color: .red)
        case .Guitar:
            return Square(size: CGSize(width: 120, height: 120), color: .green)
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
        }
    }
}
