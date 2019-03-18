import UIKit

public class Shape: CAShapeLayer {
    
    private var color: Color {
        didSet {
            self.fillColor = self.color.toRGBColor().cgColor
        }
    }
    
    public required init(color: Color) {
        self.color = color
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getColor() -> Color {
        return self.color
    }
    
}
