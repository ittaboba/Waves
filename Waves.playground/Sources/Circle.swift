import SpriteKit

public class Circle: Shape {
    
    public required init(diameter: CGFloat, color: UIColor) {
        super.init(color: color)
        self.path = Circle.path(radius: diameter / 2)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(color: UIColor) {
        super.init(color: color)
    }
    

    class func path(radius: CGFloat) -> CGMutablePath {
        let path = CGMutablePath()
        path.addArc(center: CGPoint.zero,
                    radius: radius,
                    startAngle: 0,
                    endAngle: CGFloat.pi * 2,
                    clockwise: true)
        return path
    }
}

