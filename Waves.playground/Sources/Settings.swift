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
            Color(hue: 0, saturation: 100, value: 100),
            Color(hue: 240, saturation: 100, value: 100),
            Color(hue: 120, saturation: 100, value: 100),
            Color(hue: 60, saturation: 100, value: 100),
            Color(hue: 180, saturation: 100, value: 100),
            
            //...
        ]
        
        self.instrumentTypes = [
            InstrumentType.Piano,
            InstrumentType.Guitar,
            InstrumentType.Trumpet
        ]
        
        self.shapes = [
            Circle(color: defaultColors[0]),
            Square(color: defaultColors[1]),
            Triangle(color: defaultColors[2])
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

