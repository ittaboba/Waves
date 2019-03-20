import UIKit

public class Shape: CAShapeLayer {
    
    private var color = Color(hue: 0, saturation: 0, value: 0) {
        didSet {
            self.fillColor = self.color.toRGBColor().cgColor
        }
    }
    
    public required init(color: Color) {
        self.color = color
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public func getColor() -> Color {
        return self.color
    }
    
    public func setColor(color: Color) {
        self.color = color
    }
    
}
