import UIKit

public enum DisplayMode {
    case Light
    case Dark
}

public class Settings {
    
    private var displayMode = DisplayMode.Light
    
    private var defaultInstruments = [InstrumentType]()
    private var defaultColors = [Color]()
    private var defaultShapes = [Shape]()
    
    private var shapes = [Shape]()
    
    private init() {
        self.defaultInstruments = [
            InstrumentType.Piano,
            InstrumentType.Guitar,
            InstrumentType.Trumpet
        ]
        
        self.defaultColors = [
            Color(hue: 0, saturation: 100, value: 100),
            Color(hue: 60, saturation: 100, value: 100),
            Color(hue: 120, saturation: 100, value: 100),
            Color(hue: 180, saturation: 100, value: 100),
            Color(hue: 240, saturation: 100, value: 100)
            //...
        ]
        
        self.defaultShapes = [
            Circle(color: self.defaultColors[0]),
            Square(color: self.defaultColors[1]),
            Triangle(color: self.defaultColors[2]),
            Pentagon(color: self.defaultColors[3]),
            Hexagon(color: self.defaultColors[4])
        ]
        
        self.shapes = self.defaultShapes
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
    
    public func getDefaultColors() -> [Color] {
        return self.defaultColors
    }
    
    public func getDefaultShapes() -> [Shape] {
        return self.defaultShapes
    }
    
    public func getShape(forInstrument type: InstrumentType) -> Shape {
        let instrumentIndex = self.defaultInstruments.firstIndex(of: type)
        return self.shapes[instrumentIndex!]
    }
    
    public func setShape(shape: Shape, forInstrument type: InstrumentType) {
        let instrumentIndex = self.defaultInstruments.firstIndex(of: type)
        self.shapes[instrumentIndex!] = shape
    }
}

