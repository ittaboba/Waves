import UIKit
import SpriteKit

public class Shape: SKShapeNode {
    
    private var color: UIColor {
        didSet {
            self.fillColor = self.color
        }
    }
    
    public required init(color: UIColor) {
        self.color = color
        super.init()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getColor() -> UIColor {
        return self.color
    }
    
}
