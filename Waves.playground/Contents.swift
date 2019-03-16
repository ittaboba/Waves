import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
    private var difficultyLevel: DifficultyLevel = .Easy
    private var instruments = [Instrument]()
    
    public init() {
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
        
        let difficultySegmentedControl = DifficultySegmentedControl(frame: CGRect(x: 250, y: 50, width: 300, height: 40),
                                                          levels: DifficultyLevel.levels)
        difficultySegmentedControl.delegate = self
        self.view.addSubview(difficultySegmentedControl)
        
        self.instruments = [
            Instrument(withType: .Piano, shape: Circle(diameter: 40, color: .red)),
            Instrument(withType: .Guitar, shape: Square(size: CGSize(width: 40, height: 40), color: .green))
        ]
        let instrumentSegmentedControl = InstrumentSegmentedControl(frame: CGRect(x: 250, y: 200, width: 80, height: 40),
                                                                    instruments: self.instruments)
        self.view.addSubview(instrumentSegmentedControl)
 
    }
}

extension HomeViewController: DifficultySegmentedControlDelegate {
    func difficultyLevelChanged(level: DifficultyLevel) {
        self.difficultyLevel = level
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

