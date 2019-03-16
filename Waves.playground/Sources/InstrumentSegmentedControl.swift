import UIKit

public class InstrumentSegmentedControl: UIControl {
    
    private var icons = [UIImageView]()
    private var instruments = [Instrument]()
    
    private var thumbView = UIView()
    
    private var selectedIndex: Int = 0 {
        didSet {
            self.displayNewSelectedIndex()
        }
    }
    
    private var selectedIconColor = UIColor.black {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var unselectedIconColor = UIColor.black {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var thumbColor = UIColor.brown {
        didSet {
            self.thumbView.backgroundColor = self.thumbColor
        }
    }
    
    private var thumbShape = Shape(color: .black) {
        didSet {
            let layer = CAShapeLayer()
            layer.path = self.thumbShape.path
            layer.position = CGPoint(x: 20, y: 20)
            self.thumbView.layer.mask = layer
        }
    }
    
    public init(frame: CGRect, instruments: [Instrument]) {
        super.init(frame: frame)
        
        self.instruments = instruments
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        for index in 1 ... self.instruments.count {
            let icon = UIImageView(frame: CGRect(x: 40 * (index - 1), y: 0, width: 20, height: 20))
            icon.image = UIImage(named: "icon.png")
            icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = index == 0 ? self.selectedIconColor : self.unselectedIconColor
            self.addSubview(icon)
            self.icons.append(icon)
        }
        
        self.insertSubview(self.thumbView, at: 0)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
                
        var selectFrame = self.bounds
        let newWidth = selectFrame.size.width / CGFloat(self.icons.count)
        selectFrame.size.width = newWidth
        self.thumbView.frame = selectFrame
        
        self.thumbShape = self.instruments[0].getShape() as! Circle
        
        self.displayNewSelectedIndex()
    }
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in icons.enumerated() {
            if item.frame.contains(location) {
                calculatedIndex = index
            }
        }
        
        if calculatedIndex != nil {
            self.selectedIndex = calculatedIndex!
            sendActions(for: .valueChanged)
        }
        
        return false
    }
    
    private func displayNewSelectedIndex() {
        for (_, item) in icons.enumerated() {
            item.tintColor = self.unselectedIconColor
        }
        
        let icon = icons[selectedIndex]
        icon.tintColor = self.selectedIconColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            self.thumbView.frame = CGRect(x: icon.frame.origin.x - 10, y: icon.frame.origin.y - 10, width: 40, height: 40)
            
            self.thumbColor = self.instruments[self.selectedIndex].getShape().getColor()
            
            if self.instruments[self.selectedIndex].getShape() is Circle {
                self.thumbShape = self.instruments[self.selectedIndex].getShape() as! Circle
            } else if self.instruments[self.selectedIndex].getShape() is Square {
                self.thumbShape = self.instruments[self.selectedIndex].getShape() as! Square
            }
            
        }, completion: nil)
    }
    
    private func setSelectedColors() {
        for icon in self.icons {
            icon.tintColor = self.unselectedIconColor
        }
        
        if self.icons.count > 0 {
            self.icons[0].tintColor = self.selectedIconColor
        }
    }
}

