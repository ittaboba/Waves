import SpriteKit

public class Circle: Shape {
    
    private var diameter: CGFloat = 0 {
        didSet {
            self.path = Circle.path(radius: diameter / 2)
        }
    }
    
    public required init(diameter: CGFloat, color: UIColor) {
        super.init(color: color)
        self.path = Circle.path(radius: diameter/2)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required public init(color: UIColor) {
        super.init(color: color)
    }
    
    public func setDiameter(diameter: CGFloat) {
        self.diameter = diameter
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

