import SpriteKit

public class Circle: Shape {
    
    private var diameter: CGFloat = 0 {
        didSet {
            self.path = Circle.path(radius: diameter / 2).cgPath
        }
    }
    
    public required init(diameter: CGFloat, color: Color) {
        super.init(color: color)
        self.path = Circle.path(radius: diameter/2).cgPath
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(color: Color) {
        super.init(color: color)
    }
    
    public func setDiameter(diameter: CGFloat) {
        self.diameter = diameter
    }

    class func path(radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius),
                                radius: radius,
                                startAngle: 0,
                                endAngle: CGFloat(Double.pi * 2),
                                clockwise: true)
        return path
    }
}

