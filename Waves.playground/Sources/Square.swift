import UIKit

private let border: CGFloat = 10

public class Square: Shape {
    
    private var size = CGSize(width: 160, height: 160) {
        didSet{
            self.path = Square.path(withSize: self.size).cgPath
        }
    }
    
    required public init(color: Color, size: CGSize) {
        self.size = size
        super.init(color: color)
        self.path = Square.path(withSize: size).cgPath
        self.lineWidth = border
        self.strokeColor = color.toRGBColor().cgColor
        self.lineJoin = .round
        self.lineCap = .round
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public required init(color: Color) {
        super.init(color: color)
    }
    
    public override init(layer: Any) {
        super.init(layer: layer)
    }
    
    public func setSize(size: CGSize) {
        self.size = size
    }
    
    class func path(withSize size: CGSize) -> UIBezierPath {
        let path = UIBezierPath(rect: CGRect(x: border/2,
                                             y: border/2,
                                             width: size.width - border,
                                             height: size.height - border))
        return path
    }
}

