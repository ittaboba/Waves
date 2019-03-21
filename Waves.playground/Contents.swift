import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
    private let displayMode = DisplayMode.Light
    
    private var difficultyLevel: DifficultyLevel = .Easy
    private var selectedInstrument: Instrument = InstrumentFactory.shared().createInstrument(withType: .Piano)
    
    private var instruments = [Instrument]()
    private var instrumentTypes = [InstrumentType]()
    
    private var viewTitle: UILabel!
    
    private var instrumentSegmentedControl: InstrumentSegmentedControl!
    private var difficultySegmentedControl: DifficultySegmentedControl!
    
    private let settingsButton = UIButton(type: .custom)
    private let playButton = UIButton(type: .custom)
    
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
        
        // create instruments
        self.instrumentTypes = Settings.shared().getInstrumentTypes()
        for instrumentType in self.instrumentTypes {
            let instrument = InstrumentFactory.shared().createInstrument(withType: instrumentType)
            self.instruments.append(instrument)
        }
        
        self.viewTitle = UILabel(frame: CGRect(x: SharedValues.shared().getHomeLabelTitle().getX(),
                                               y: SharedValues.shared().getHomeLabelTitle().getY(),
                                               width: SharedValues.shared().getHomeLabelTitle().getWidth(),
                                               height: SharedValues.shared().getHomeLabelTitle().getHeight()))
        self.viewTitle.text = SharedValues.shared().getHomeLabelTitle().getTitle()
        self.viewTitle.textAlignment = .center
        self.viewTitle.font = UIFont(name: SharedValues.shared().getSanFranciscoHeavyFont().getName(), size: 60)
        self.viewTitle.textColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.view.addSubview(self.viewTitle)

        self.settingsButton.setTitle(SharedValues.shared().getSettingsButton().getTitle(), for: .normal)
        self.settingsButton.frame = CGRect(x: SharedValues.shared().getSettingsButton().getX(),
                                           y: SharedValues.shared().getSettingsButton().getY(),
                                           width: SharedValues.shared().getSettingsButton().getWidth(),
                                           height: SharedValues.shared().getSettingsButton().getHeight())
        self.settingsButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.settingsButton.titleLabel?.textAlignment = .center
        self.settingsButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.settingsButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.settingsButton.layer.cornerRadius = SharedValues.shared().getSettingsButton().getHeight() / 2
        self.settingsButton.addTarget(self, action: #selector(HomeViewController.openSettings(sender:)), for: .touchUpInside)
        self.view.addSubview(self.settingsButton)
        
        
        self.instrumentSegmentedControl =
            InstrumentSegmentedControl(frame:CGRect(x: SharedValues.shared().getInstrumentSegmentedControl().getX(),
                                                    y: SharedValues.shared().getInstrumentSegmentedControl().getY(),
                                                    width: SharedValues.shared().getInstrumentSegmentedControl().getWidth(),
                                                    height: SharedValues.shared().getInstrumentSegmentedControl().getHeight()),
                                       instruments: self.instruments)
        self.instrumentSegmentedControl.backgroundColor = .clear
        self.instrumentSegmentedControl.delegate = self
        self.view.addSubview(self.instrumentSegmentedControl)
        
        
        self.difficultySegmentedControl =
            DifficultySegmentedControl(frame: CGRect(x: SharedValues.shared().getDifficultySegmentedControl().getX(),
                                                     y: SharedValues.shared().getDifficultySegmentedControl().getY(),
                                                     width: SharedValues.shared().getDifficultySegmentedControl().getWidth(),
                                                     height: SharedValues.shared().getDifficultySegmentedControl().getHeight()),
                                       levels: DifficultyLevel.levels)
        self.difficultySegmentedControl.backgroundColor = .clear
        self.difficultySegmentedControl.delegate = self
        self.view.addSubview(self.difficultySegmentedControl)
        
        
        self.playButton.setTitle(SharedValues.shared().getPlayButton().getTitle(), for: .normal)
        self.playButton.frame = CGRect(x: SharedValues.shared().getPlayButton().getX(),
                                       y: SharedValues.shared().getPlayButton().getY(),
                                       width: SharedValues.shared().getPlayButton().getWidth(),
                                       height: SharedValues.shared().getPlayButton().getHeight())
        self.playButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.playButton.titleLabel?.textAlignment = .center
        self.playButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.playButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.playButton.layer.cornerRadius = SharedValues.shared().getPlayButton().getHeight() / 2
        self.playButton.addTarget(self, action: #selector(HomeViewController.playGame(sender:)), for: .touchUpInside)
        self.view.addSubview(self.playButton)
    }
    
    @objc func openSettings(sender: UIButton) {
        let settingsViewController = SettingsViewController()
        settingsViewController.settingsDelegate = self
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    @objc func playGame(sender: UIButton) {
        let gameViewController = GameViewController(withLevel: self.difficultyLevel, instrument: self.selectedInstrument)
        self.present(gameViewController, animated: true, completion: nil)
    }
 
}


extension HomeViewController: SettingsDelegate {
    func settingsDidChange() {
        self.instrumentSegmentedControl.setNeedsLayout()
    }
}

extension HomeViewController: DifficultySegmentedControlDelegate {
    func difficultyLevelChanged(level: DifficultyLevel) {
        self.difficultyLevel = level
    }
}

extension HomeViewController: InstrumentSegmentedControlDelegate {
    func instrumentChanged(instrument: Instrument) {
        self.selectedInstrument = instrument
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

