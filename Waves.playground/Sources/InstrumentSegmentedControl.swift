import UIKit

public protocol InstrumentSegmentedControlDelegate: class {
    func instrumentChanged(instrumentType: InstrumentType)
}

public class InstrumentSegmentedControl: UIControl {
    
    public weak var delegate: InstrumentSegmentedControlDelegate?
    
    private var icons = [UIImageView]()
    private var instruments = [Instrument]()
    
    private var thumbView = UIView()
    
    private var selectedIndex: Int = 0 {
        didSet {
            self.delegate?.instrumentChanged(instrumentType: self.instruments[selectedIndex].getType())
            self.displayNewSelectedIndex()
        }
    }
    
    private var selectedIconColor = UIColor.white {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var unselectedIconColor = UIColor.white {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var thumbColor = UIColor.brown {
        didSet {
            self.thumbView.backgroundColor = self.thumbColor
        }
    }
    
    private var thumbShape = Shape(color: Color(hue: 0, saturation: 0, value: 0)) {
        didSet {
            self.thumbView.layer.mask = self.thumbShape
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
            let icon = UIImageView(frame: CGRect(x: 120 * (index - 1) + 40, y: 40, width: 40, height: 40))
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
        
        self.setThumbShape(atSelectedIndex: self.selectedIndex)
        
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
            self.thumbView.frame = CGRect(x: icon.frame.origin.x - 40, y: icon.frame.origin.y - 40, width: 120, height: 120)
            
            self.thumbColor = self.instruments[self.selectedIndex].getType().getShape().getColor().toRGBColor()
            
            self.setThumbShape(atSelectedIndex: self.selectedIndex)
            
        }, completion: nil)
    }
    
    private func setThumbShape(atSelectedIndex index: Int) {
        if self.instruments[index].getType().getShape() is Circle {
            self.thumbShape = self.instruments[index].getType().getShape() as! Circle
        } else if self.instruments[index].getType().getShape() is Square {
            self.thumbShape = self.instruments[index].getType().getShape() as! Square
        } else if self.instruments[index].getType().getShape() is Triangle {
            self.thumbShape = self.instruments[index].getType().getShape() as! Triangle
        }
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

