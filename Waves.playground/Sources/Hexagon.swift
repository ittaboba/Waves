
import UIKit

public class Hexagon: Shape {
    
    required public init(color: Color) {
        super.init(color: color)
        self.path = Hexagon.path().cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func path() -> UIBezierPath {
        let polygonPath = UIBezierPath()
        
        polygonPath.move(to: CGPoint(x: 60, y: 0))
        polygonPath.addLine(to: CGPoint(x: 120, y: 28))
        polygonPath.addLine(to: CGPoint(x: 120, y: 92))
        polygonPath.addLine(to: CGPoint(x: 60, y: 120))
        polygonPath.addLine(to: CGPoint(x: 0, y: 92))
        polygonPath.addLine(to: CGPoint(x: 0, y: 28))
        polygonPath.addLine(to: CGPoint(x: 60, y: 0))
        polygonPath.close()
        
        return polygonPath
    }
}

