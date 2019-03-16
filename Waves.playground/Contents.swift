import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
    private let instruments = [
        Instrument(withType: .Piano, shape: Circle(diameter: 100, color: .red)),
        Instrument(withType: .Guitar, shape: Square(size: CGSize(width: 120, height: 120), color: .green)),
        Instrument(withType: .Piano, shape: Square(size: CGSize(width: 120, height: 120), color: .green)),
        Instrument(withType: .Guitar, shape: Triangle(size: CGSize(width: 120, height: 120), color: .green)),
        Instrument(withType: .Guitar, shape: Square(size: CGSize(width: 120, height: 120), color: .green))
    ]
    
    private var difficultyLevel: DifficultyLevel = .Easy
    private var instrument: Instrument
    
    public init() {
        self.instrument = self.instruments[0]
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = UIView(frame: CGRect(x: SharedValues.shared.getHomeView().getX(),
                                         y: SharedValues.shared.getHomeView().getY(),
                                         width: SharedValues.shared.getHomeView().getWidth(),
                                         height: SharedValues.shared.getHomeView().getHeight()))
        self.view.backgroundColor = SharedValues.shared.getHomeView().getBackgroundColor()
        
        let difficultySegmentedControl = DifficultySegmentedControl(frame: CGRect(x: 220, y: 300, width: 360, height: 50),
                                                          levels: DifficultyLevel.levels)
        difficultySegmentedControl.delegate = self
        self.view.addSubview(difficultySegmentedControl)
        
        let instrumentSegmentedControl = InstrumentSegmentedControl(frame: CGRect(x: 100, y: 100, width: 600, height: 120),
                                                                    instruments: self.instruments)
        instrumentSegmentedControl.backgroundColor = .brown
        instrumentSegmentedControl.delegate = self
        self.view.addSubview(instrumentSegmentedControl)
 
    }
}

extension HomeViewController: DifficultySegmentedControlDelegate {
    func difficultyLevelChanged(level: DifficultyLevel) {
        self.difficultyLevel = level
    }
}

extension HomeViewController: InstrumentSegmentedControlDelegate {
    func instrumentChanged(instrument: Instrument) {
        self.instrument = instrument
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

