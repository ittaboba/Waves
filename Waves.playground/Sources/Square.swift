import SpriteKit

public class Square: Shape {
        
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
    
    class func path(size: CGSize) -> UIBezierPath {
        let path = UIBezierPath()
    
        path.move(to: CGPoint(x: -size.width/2, y: -size.height/2))
        path.addLine(to: CGPoint(x: size.width/2, y: -size.height/2))
        path.addLine(to: CGPoint(x: size.width/2, y: size.height/2))
        path.addLine(to: CGPoint(x: -size.width/2, y: size.height/2))
        path.addLine(to: CGPoint(x: -size.width/2, y: -size.height/2))
 
        path.close()
        return path
    }
}

