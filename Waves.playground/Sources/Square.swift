import SpriteKit

public class Square: Shape {
    
    private var size = CGSize(width: 0, height: 0) {
        didSet {
            self.path = Triangle.path(size: self.size)
        }
    }
        
    required public init(size: CGSize, color: UIColor) {
        super.init(color: color)
        self.path = Square.path(size: size).cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(color: UIColor) {
        super.init(color: color)
    }
    
    public func setSize(size: CGSize) {
        self.size = size
    }
    
    class func path(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return path
    }
}

