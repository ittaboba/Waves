import UIKit

public class Square: Shape {
    
    required public init(color: Color) {
        super.init(color: color)
        self.path = Square.path().cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func path() -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 120, height: 120))
        return path
    }
}

