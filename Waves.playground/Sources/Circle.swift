
import UIKit

public class Circle: Shape {
    
    public required init(color: Color) {
        super.init(color: color)
        self.path = Circle.path().cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    class func path() -> UIBezierPath {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 160, height: 160))
        return path
    }
}

