import SpriteKit

public class Square: Shape {
    
    private var size = CGSize(width: 0, height: 0) {
        didSet {
            self.path = Square.path(size: self.size).cgPath
        }
    }
        
    required public init(size: CGSize, color: Color) {
        super.init(color: color)
        self.path = Square.path(size: size).cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(color: Color) {
        super.init(color: color)
    }
    
    public func setSize(size: CGSize) {
        self.size = size
    }
    
    class func path(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), cornerRadius: 10)
        return path
    }
}

