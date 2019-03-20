
import UIKit

public class Triangle: Shape {
    
    required public init(color: Color) {
        super.init(color: color)
        self.path = Triangle.path().cgPath
        self.lineWidth = 20
        self.strokeColor = color.toRGBColor().cgColor
        self.lineJoin = .round
        self.lineCap = .round
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    class func path() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 80, y: 10))
        path.addLine(to: CGPoint(x: 150, y: 150))
        path.addLine(to: CGPoint(x: 10, y: 150))
        path.addLine(to: CGPoint(x: 80, y: 10))
                
        return path
    }
}

