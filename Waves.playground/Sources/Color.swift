
import UIKit

internal enum HSVColorError: Error {
    case UndefinedValue
    case UndefinedHue
}

public class Color {
    private var hue: CGFloat
    private var saturation: CGFloat
    private var value: CGFloat
    
    public init(){
        self.hue = 0.0
        self.saturation = 0.0
        self.value = 0.0
    }
    
    public init(hue: CGFloat, saturation: CGFloat, value: CGFloat) {
        self.hue = hue
        self.saturation = saturation
        self.value = value
    }
    
    public func fromRGBColor(color: UIColor)  {
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        
        if let redComponent = color.cgColor.components?[0] {
            red = redComponent
        }
        
        if let greenComponent = color.cgColor.components?[1] {
            green = greenComponent
        }
        
        if let blueComponent = color.cgColor.components?[2] {
            blue = blueComponent
        }
        
        let M = max(red, green, blue)
        let m = min(red, green, blue)
        
        // Chroma is the difference between the largest and the smallest values among R, G or B in a color
        let chroma = M - m
        
        // VALUE is defined as the largest component of a color
        self.value = M * 100
        
        guard chroma != 0 else {
            self.saturation = 0
            self.hue = 0
            return
        }
        
        // SATURATION
        self.saturation = chroma / M
        
        // HUE
        var hue: CGFloat
        if red == M {
            hue = ((green - blue)/chroma).truncatingRemainder(dividingBy: 6)
        } else if green == M {
            hue = (blue - red)/chroma + 2.0
        } else {
            hue = (red - green)/chroma + 4.0
        }
        
        hue *= 60.0
        
        if hue < 0 {
            hue += 360.0
        }
        
        self.hue = hue
        self.saturation *= 100
        
    }
    
    public func toRGBColor() -> UIColor {
        var hue: CGFloat
        let saturation = self.saturation/100
        let value = self.value/100
        
        if saturation == 0 {
            return UIColor(red: value, green: value, blue: value, alpha: 1)
        }else {
            var i: Int
            var f, p, q, t: CGFloat
            
            if self.hue == 360 {
                self.hue = 0
            }
            
            hue = self.hue / 60.0
            i = Int(hue)
            f = hue - CGFloat(i)
            
            p = value * (1.0 - saturation)
            q = value * (1.0 - (saturation * f))
            t = value * (1.0 - (saturation * (1.0 - f)))
            
            switch i {
            case 0:
                return UIColor(red: value, green: t, blue: p, alpha: 1)
            case 1:
                return UIColor(red: q, green: value, blue: p, alpha: 1)
            case 2:
                return UIColor(red: p, green: value, blue: t, alpha: 1)
            case 3:
                return UIColor(red: p, green: q, blue: value, alpha: 1)
            case 4:
                return UIColor(red: t, green: p, blue: value, alpha: 1)
            case 5:
                return UIColor(red: value, green: p, blue: q, alpha: 1)
            default:
                return UIColor()
            }
        }
    }
    
    public func getHue() -> CGFloat {
        return self.hue
    }
    
    public func getSaturation() -> CGFloat {
        return self.saturation
    }
    
    public func getValue() -> CGFloat {
        return self.value
    }
}











