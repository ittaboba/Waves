import UIKit

public protocol DifficultySegmentedControlDelegate: class {
    func difficultyLevelChanged(level: DifficultyLevel)
}

public class DifficultySegmentedControl: UIControl {
    
    public weak var delegate: DifficultySegmentedControlDelegate?

    private var labels = [UILabel]()
    private var levels = [DifficultyLevel]()
    
    private var thumbView = UIView()
    
    private var selectedIndex: Int = 0 {
        didSet {
            self.delegate?.difficultyLevelChanged(level: DifficultyLevel.levels[selectedIndex])
            self.displayNewSelectedIndex()
        }
    }

    private var selectedLabelColor = UIColor.black {
        didSet {
            self.setSelectedColors()
        }
    }

    private var unselectedLabelColor = UIColor.black {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var thumbColor = UIColor.yellow {
        didSet {
            self.setSelectedColors()
        }
    }
    
    private var font = UIFont.systemFont(ofSize: 12) {
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
            let label = UILabel(frame: CGRect(x: 75 * (index - 1), y: 0, width: 75, height: 40))
            label.text = self.levels[index - 1].rawValue
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.font = UIFont(name: "Helvetica", size: 15)
            label.textColor = index == 0 ? self.selectedLabelColor : self.unselectedLabelColor
            self.addSubview(label)
            self.labels.append(label)
        }
        
        self.insertSubview(self.thumbView, at: 0)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        var selectFrame = self.bounds
        let newWidth = selectFrame.size.width / CGFloat(self.levels.count)
        selectFrame.size.width = newWidth
        self.thumbView.frame = selectFrame
        self.thumbView.backgroundColor = self.thumbColor
        self.thumbView.layer.cornerRadius = selectFrame.size.height / 2
        
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
            self.thumbView.frame = label.frame
        }, completion: nil)
    }
    
    private func setSelectedColors(){
        for item in self.labels {
            item.textColor = self.unselectedLabelColor
        }
        
        if self.labels.count > 0 {
            self.labels[0].textColor = self.selectedLabelColor
        }
        
        self.thumbView.backgroundColor = self.thumbColor
    }
    
    private func setFont(){
        for item in labels {
            item.font = self.font
        }
    }
}

