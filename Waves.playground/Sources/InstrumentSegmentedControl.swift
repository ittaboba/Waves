import UIKit

public protocol InstrumentSegmentedControlDelegate: class {
    /**
     Called when the user has changed the instrument selection
     - parameters:
     instrument: the new instrument selected
     */
    func instrumentChanged(instrument: Instrument)
}

private let selectedViewWidth: CGFloat = 160
private let selectedViewHeight: CGFloat = 160
private let iconWidth: CGFloat = 60
private let iconHeight: CGFloat = 45

public class InstrumentSegmentedControl: UIControl {
    
    public weak var delegate: InstrumentSegmentedControlDelegate?
    
    private var viewWidth: CGFloat = 0
    private var viewHeight: CGFloat = 0
    
    private var selectedViewHorizontalMargin: CGFloat = 0
    private var iconHorizontalMargin: CGFloat = selectedViewWidth/2 - iconWidth/2
    private var iconVerticalMargin: CGFloat = selectedViewHeight/2 - iconHeight/2
    
    private var icons = [UIImageView]()
    private var instruments = [Instrument]()
    
    private var selectedView = UIView()
    
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
    
    private var selectedColor = UIColor.clear {
        didSet {
            self.selectedView.backgroundColor = self.selectedColor
        }
    }
    
    private var selectedShape = Shape(color: Color(hue: 0, saturation: 0, value: 0)) {
        didSet {
            self.selectedView.layer.mask = self.selectedShape
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
        
        self.viewWidth = self.frame.size.width
        self.viewHeight = self.frame.size.height
        
        self.selectedViewHorizontalMargin = (self.viewWidth - (CGFloat(self.instruments.count) * selectedViewWidth))/CGFloat(self.instruments.count - 1)
        
        for index in 1 ... self.instruments.count {
            let iconOffset1 = self.iconHorizontalMargin * CGFloat(index)
            let iconOffset2 = (iconWidth + self.iconHorizontalMargin + self.selectedViewHorizontalMargin) * CGFloat(index - 1)
        
            let x = iconOffset1 + iconOffset2
            let icon = UIImageView(frame:
                CGRect(x: x,
                       y: self.iconVerticalMargin,
                       width: iconWidth,
                       height: iconHeight))
            icon.image = self.instruments[index - 1].getIcon()
            icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
            icon.tintColor = index == 0 ? self.selectedIconColor : self.unselectedIconColor
            self.addSubview(icon)
            self.icons.append(icon)
        }
        
        self.insertSubview(self.selectedView, at: 0)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
                
        var selectFrame = self.bounds
        let newWidth = selectFrame.size.width / CGFloat(self.icons.count)
        selectFrame.size.width = newWidth
        self.selectedView.frame = selectFrame
        
        let shape = self.instruments[self.selectedIndex].getType().getShape(withSize: CGSize(width: selectedViewWidth, height: selectedViewHeight))
        self.selectedShape = shape
        
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
            self.selectedView.frame = CGRect(x: icon.frame.origin.x - self.iconHorizontalMargin,
                                          y: icon.frame.origin.y - self.iconVerticalMargin,
                                          width: selectedViewWidth,
                                          height: selectedViewHeight)
            
            let shape = self.instruments[self.selectedIndex].getType().getShape(withSize: CGSize(width: selectedViewWidth, height: selectedViewHeight))
            self.selectedColor = shape.getColor().toRGBColor()
            self.selectedShape = shape
            
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

