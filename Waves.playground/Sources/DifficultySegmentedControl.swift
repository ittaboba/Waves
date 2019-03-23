import UIKit

public protocol DifficultySegmentedControlDelegate: class {
    /**
     Called when the user has changed the diffculty level selection
     - parameters:
     level: the new difficulty level type selected
    */
    func difficultyLevelChanged(level: DifficultyLevel)
}

public class DifficultySegmentedControl: UIControl {
    
    public weak var delegate: DifficultySegmentedControlDelegate?

    private var labels = [UILabel]()
    private var levels = [DifficultyLevel]()
    
    private var selectedView = UIView()
    
    private var selectedIndex: Int = 0 {
        didSet {
            self.delegate?.difficultyLevelChanged(level: DifficultyLevel.levels[selectedIndex])
            self.displayNewSelectedIndex()
        }
    }

    private var selectedLabelColor = Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black {
        didSet {
            self.setSelectedColors()
        }
    }

    private var unselectedLabelColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var selectedColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white {
        didSet {
            self.selectedView.backgroundColor = self.selectedColor
        }
    }
    
    private var font = UIFont.systemFont(ofSize: 18) {
        didSet {
            setFont()
        }
    }
    
    public init(frame: CGRect, levels: [DifficultyLevel]) {
        super.init(frame: frame)
        
        self.levels = levels
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        for index in 1 ... self.levels.count {
            let label = UILabel(frame: CGRect(x: 150 * (index - 1), y: 0, width: 150, height: 50))
            label.text = self.levels[index - 1].rawValue
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
            label.textColor = index == 0 ? self.selectedLabelColor : self.unselectedLabelColor
            self.addSubview(label)
            self.labels.append(label)
        }
        
        self.insertSubview(self.selectedView, at: 0)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.size.width / CGFloat(self.levels.count)
        selectFrame.size.width = newWidth
        self.selectedView.frame = selectFrame
        
        self.selectedView.layer.cornerRadius = selectFrame.size.height / 2
        
        self.displayNewSelectedIndex()
    }
    
    override public func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        var calculatedIndex : Int?
        for (index, item) in labels.enumerated() {
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
    
    private func displayNewSelectedIndex(){
        for (_, item) in labels.enumerated() {
            item.textColor = self.unselectedLabelColor
        }
        
        let label = labels[selectedIndex]
        label.textColor = self.selectedLabelColor
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            self.selectedView.frame = label.frame
            self.selectedLabelColor = Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black
        }, completion: nil)
    }
    
    private func setSelectedColors(){
        for index in 0 ..< self.labels.count {
            if(index != self.selectedIndex) {
                self.labels[index].textColor = self.unselectedLabelColor
            } else {
                self.labels[index].textColor = self.selectedLabelColor
            }
        }
        
        self.selectedView.backgroundColor = self.selectedColor
    }
    
    private func setFont(){
        for item in labels {
            item.font = self.font
        }
    }
}

