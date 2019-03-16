

public class PianoInstrument: Instrument {
    public var shape: Shape
    
    init(withShape shape: Shape) {
        self.shape = shape
    }
    
    public func getType() -> InstrumentType {
        return .Piano
    }
}
