import UIKit

public protocol InstrumentSegmentedControlDelegate: class {
    func instrumentChanged(instrument: Instrument)
}

public class InstrumentSegmentedControl: UIControl {
    
    public weak var delegate: InstrumentSegmentedControlDelegate?
    
    private var icons = [UIImageView]()
    private var instruments = [Instrument]()
    
    private var thumbView = UIView()
    
    private var selectedIndex: Int = 0 {
        didSet {
            self.delegate?.instrumentChanged(instrument: self.instruments[selectedIndex])
            self.displayNewSelectedIndex()
        }
    }
    
    private var selectedIconColor = Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var unselectedIconColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var thumbColor = UIColor.clear {
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
            let icon = UIImageView(frame: CGRect(x: (30 * index) + (60 * index) + ((40 + 60) * (index - 1)), y: 60, width: 40, height: 40))
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
        
        let shape = self.instruments[self.selectedIndex].getType().getShape()
        self.thumbShape = shape
        
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
            self.thumbView.frame = CGRect(x: icon.frame.origin.x - 60, y: icon.frame.origin.y - 60, width: 160, height: 160)
            
            let shape = self.instruments[self.selectedIndex].getType().getShape()
            
            self.thumbColor = shape.getColor().toRGBColor()
            self.thumbShape = shape
            
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

