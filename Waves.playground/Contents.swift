import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
    private let displayMode = DisplayMode.Light
    
    private let instruments = [
        InstrumentFactory.shared().createInstrument(withType: .Piano),
        InstrumentFactory.shared().createInstrument(withType: .Guitar),
        InstrumentFactory.shared().createInstrument(withType: .Trumpet)
    ]
    
    private var difficultyLevel: DifficultyLevel = .Easy
    private var instrumentType: InstrumentType = .Piano
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        Settings.shared().setDisplayMode(mode: self.displayMode)
        
        self.view = UIView(frame: CGRect(x: SharedValues.shared().getHomeView().getX(),
                                         y: SharedValues.shared().getHomeView().getY(),
                                         width: SharedValues.shared().getHomeView().getWidth(),
                                         height: SharedValues.shared().getHomeView().getHeight()))
        self.view.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .white : .black
        
        let settingsButton = UIButton(type: .custom)
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.frame = CGRect(x: 460,
                                      y: 20,
                                      width: 120,
                                      height: 40)
        settingsButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        settingsButton.titleLabel?.textAlignment = .center
        settingsButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: "Helvetica", size: 22)
        settingsButton.layer.cornerRadius = settingsButton.frame.size.height / 2
        settingsButton.addTarget(self, action: #selector(HomeViewController.openSettings(sender:)), for: .touchUpInside)
        self.view.addSubview(settingsButton)
        
        let instrumentSegmentedControl = InstrumentSegmentedControl(frame: CGRect(x: SharedValues.shared().getInstrumentSegmentedControl().getX(),
                                                                                  y: SharedValues.shared().getInstrumentSegmentedControl().getY(),
                                                                                  width: SharedValues.shared().getInstrumentSegmentedControl().getWidth(),
                                                                                  height: SharedValues.shared().getInstrumentSegmentedControl().getHeight()),
                                                                    instruments: self.instruments)
        instrumentSegmentedControl.backgroundColor = .brown
        instrumentSegmentedControl.delegate = self
        self.view.addSubview(instrumentSegmentedControl)
        
        
        let difficultySegmentedControl = DifficultySegmentedControl(frame: CGRect(x: SharedValues.shared().getDifficultySegmentedControl().getX(),
                                                                                  y: SharedValues.shared().getDifficultySegmentedControl().getY(),
                                                                                  width: SharedValues.shared().getDifficultySegmentedControl().getWidth(),
                                                                                  height: SharedValues.shared().getDifficultySegmentedControl().getHeight()),
                                                                    levels: DifficultyLevel.levels)
        difficultySegmentedControl.backgroundColor = .clear
        difficultySegmentedControl.delegate = self
        self.view.addSubview(difficultySegmentedControl)
        
        
        let playButton = UIButton(type: .custom)
        playButton.setTitle(SharedValues.shared().getPlayButton().getTitle(), for: .normal)
        playButton.frame = CGRect(x: SharedValues.shared().getPlayButton().getX(),
                                  y: SharedValues.shared().getPlayButton().getY(),
                                  width: SharedValues.shared().getPlayButton().getWidth(),
                                  height: SharedValues.shared().getPlayButton().getHeight())
        playButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        playButton.titleLabel?.textAlignment = .center
        playButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        playButton.titleLabel?.font = UIFont(name: "Helvetica", size: 22)
        playButton.layer.cornerRadius = playButton.frame.size.height / 2
        playButton.addTarget(self, action: #selector(HomeViewController.playGame(sender:)), for: .touchUpInside)
        self.view.addSubview(playButton)
    }
    
    @objc func openSettings(sender: UIButton) {
        let settingsViewController = SettingsViewController()
        self.present(settingsViewController, animated: true, completion: nil)
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

