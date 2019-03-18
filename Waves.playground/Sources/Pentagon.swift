
import UIKit

public class Pentagon: Shape {
    
    required public init(color: Color) {
        super.init(color: color)
        self.path = Pentagon.path().cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
        
    class func path() -> UIBezierPath {
        let polygonPath = UIBezierPath()
        polygonPath.move(to: CGPoint(x: 60, y: 0))
        polygonPath.addLine(to: CGPoint(x: 120, y: 50))
        polygonPath.addLine(to: CGPoint(x: 95, y: 120))
        polygonPath.addLine(to: CGPoint(x: 25, y: 120))
        polygonPath.addLine(to: CGPoint(x: 0, y: 50))
        polygonPath.addLine(to: CGPoint(x: 60, y: 0))
        polygonPath.close()
        
        return polygonPath
    }
}

