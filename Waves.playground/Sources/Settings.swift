import UIKit

public enum DisplayMode {
    case Light
    case Dark
}

public class Settings {
    
    private var displayMode = DisplayMode.Light
    
    private var instrumentTypes = [InstrumentType]()
    private var defaultColors = [Color]()
    private var shapes = [Shape]()
    
    private init() {
        self.defaultColors = [
            Color(hue: 55, saturation: 88.7, value: 97.3),
            Color(hue: 10, saturation: 44.4, value: 95.3),
            Color(hue: 9, saturation: 68.8, value: 86.7),
            Color(hue: 355, saturation: 69.1, value: 80),
            Color(hue: 272, saturation: 38.7, value: 63.9),
            Color(hue: 232, saturation: 67, value: 86.7),
            Color(hue: 212, saturation: 67.3, value: 88.6),
            Color(hue: 199, saturation: 28.6, value: 75.3),
            Color(hue: 138, saturation: 38.6, value: 51.8)
        ]
        
        self.instrumentTypes = [
            InstrumentType.Piano,
            InstrumentType.Guitar,
            InstrumentType.Trumpet
        ]
        
        self.shapes = [
            Circle(color: defaultColors[5]),
            Square(color: defaultColors[2]),
            Triangle(color: defaultColors[0])
        ]
    }
    
    private static let sharedSettings = Settings()
    
    public class func shared() -> Settings {
        return sharedSettings
    }
    
    public func getDisplayMode() -> DisplayMode {
        return self.displayMode
    }
    
    public func setDisplayMode(mode: DisplayMode) {
        self.displayMode = mode
    }
    
    public func getInstrumentTypes() -> [InstrumentType] {
        return self.instrumentTypes
    }
    
    public func getDefaultColors() -> [Color] {
        return self.defaultColors
    }
    
    public func getShapes() -> [Shape] {
        return self.shapes
    }
    
    public func setShapes(shapes: [Shape]) {
        self.shapes = shapes
    }
    
    public func getShape(forInstrument type: InstrumentType) -> Shape {
        let instrumentIndex = self.instrumentTypes.firstIndex(of: type)
        return self.shapes[instrumentIndex!]
    }
    
    public func setShape(shape: Shape, forInstrument type: InstrumentType) {
        let instrumentIndex = self.instrumentTypes.firstIndex(of: type)
        self.shapes[instrumentIndex!] = shape
    }
}

