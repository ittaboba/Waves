
import UIKit

public class Circle: Shape {
    
    private var size = CGSize(width: 160, height: 160) {
        didSet{
            self.path = Circle.path(withSize: size).cgPath
        }
    }
    
    public required init(color: Color, size: CGSize) {
        self.size = size
        super.init(color: color)
        self.path = Circle.path(withSize: self.size).cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public required init(color: Color) {
        super.init(color: color)
    }
    
    public func setSize(size: CGSize) {
        self.size = size
    }
    
    class func path(withSize size: CGSize) -> UIBezierPath {
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return path
    }
}

