
import UIKit

public class Triangle: Shape {
    
    required public init(color: Color) {
        super.init(color: color)
        self.path = Triangle.path().cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func path() -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 120))
        path.addLine(to: CGPoint(x: 120, y: 120))
        path.addLine(to: CGPoint(x: 60, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 120))
                
        return path
    }
}

