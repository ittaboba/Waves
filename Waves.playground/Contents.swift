import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
    private let instruments = [
        InstrumentFactory.shared().createInstrument(withType: .Piano),
        InstrumentFactory.shared().createInstrument(withType: .Guitar),
        InstrumentFactory.shared().createInstrument(withType: .Trumpet),
        InstrumentFactory.shared().createInstrument(withType: .Guitar),
        InstrumentFactory.shared().createInstrument(withType: .Piano)
    ]
    
    private var difficultyLevel: DifficultyLevel = .Easy
    private var instrumentType: InstrumentType = .Piano
    
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
        
        
        let instrumentSegmentedControl = InstrumentSegmentedControl(frame: CGRect(x: 80, y: 100, width: 600, height: 120),
                                                                    instruments: self.instruments)
        instrumentSegmentedControl.backgroundColor = .brown
        instrumentSegmentedControl.delegate = self
        self.view.addSubview(instrumentSegmentedControl)
        
        
        let difficultySegmentedControl = DifficultySegmentedControl(frame: CGRect(x: 200, y: 300, width: 360, height: 50),
                                                                    levels: DifficultyLevel.levels)
        difficultySegmentedControl.delegate = self
        self.view.addSubview(difficultySegmentedControl)
        
        
        let playButton = UIButton(type: .custom)
        playButton.setTitle("Play", for: .normal)
        playButton.backgroundColor = .red
        playButton.frame = CGRect(x: 320, y: 400, width: 120, height: 50)
        playButton.titleLabel?.textAlignment = .center
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.addTarget(self, action: #selector(HomeViewController.playGame(sender:)), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    
    @objc func playGame(sender: UIButton) {
        let gameViewController = GameViewController(withLevel: self.difficultyLevel, instrumentType: self.instrumentType)
        self.present(gameViewController, animated: true, completion: nil)
    }
}

extension HomeViewController: DifficultySegmentedControlDelegate {
    func difficultyLevelChanged(level: DifficultyLevel) {
        self.difficultyLevel = level
    }
}

extension HomeViewController: InstrumentSegmentedControlDelegate {
    func instrumentChanged(instrumentType: InstrumentType) {
        self.instrumentType = instrumentType
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

