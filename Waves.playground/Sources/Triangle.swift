import SpriteKit

public class Triangle: Shape {
    
    private var size = CGSize(width: 0, height: 0) {
        didSet {
            self.path = Triangle.path(size: self.size)
        }
    }
    
    required public init(size: CGSize, color: Color) {
        super.init(color: color)
        self.path = Triangle.path(size: size)
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
    
    class func path(size: CGSize) -> CGMutablePath {
        let path: CGMutablePath = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: size.width/2, y: -size.height/2))
        path.addLine(to: CGPoint(x: 0, y: size.height/2))
        path.addLine(to: CGPoint(x: -size.width/2, y: -size.height/2))
        
        return path
    }
}

