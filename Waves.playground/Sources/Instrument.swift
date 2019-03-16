import UIKit

public enum InstrumentType {
    case Piano
    case Guitar
}

public class Instrument {
    
    private var type: InstrumentType
    private var shape: Shape
    
    public init(withType type: InstrumentType, shape: Shape) {
        self.type = type
        self.shape = shape
    }
 
    public func getType() -> InstrumentType {
        return self.type
    }
    
    public func getShape() -> Shape {
        return self.shape
    }
}
