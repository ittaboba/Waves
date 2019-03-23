//: ![](Cover.pdf)

import UIKit
import AVFoundation
import PlaygroundSupport

/**
 Change DisplayMode value to play in Light or Dark mode
 */
private let displayMode = DisplayMode.Dark

class HomeViewController: UIViewController {
    
    private var difficultyLevel: DifficultyLevel = .Easy
    private var selectedInstrument: Instrument = InstrumentFactory.shared().createInstrument(withType: .Piano)
    
    private var instruments = [Instrument]()
    private var instrumentTypes = [InstrumentType]()
    
    private var viewTitle: UILabel!
    
    private var instrumentSegmentedControl: InstrumentSegmentedControl!
    private var difficultySegmentedControl: DifficultySegmentedControl!
    
    private let settingsButton = UIButton(type: .custom)
    private let playButton = UIButton(type: .custom)
    
    private var sound: AVAudioPlayer!
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func loadView() {
        // view setup
        Settings.shared().setDisplayMode(mode: displayMode)
        self.view = UIView(frame: CGRect(x: SharedValues.shared().getWindowView().getX(),
                                         y: SharedValues.shared().getWindowView().getY(),
                                         width: SharedValues.shared().getWindowView().getWidth(),
                                         height: SharedValues.shared().getWindowView().getHeight()))
        self.view.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .white : .black
        
        // create instruments
        self.instrumentTypes = Settings.shared().getInstrumentTypes()
        for instrumentType in self.instrumentTypes {
            let instrument = InstrumentFactory.shared().createInstrument(withType: instrumentType)
            self.instruments.append(instrument)
        }
        
        // title
        self.viewTitle = UILabel(frame: CGRect(x: 200, y: 30, width: 300, height: 100))
        self.viewTitle.text = "Welcome"
        self.viewTitle.textAlignment = .center
        self.viewTitle.font = UIFont(name: SharedValues.shared().getSanFranciscoHeavyFont().getName(), size: 60)
        self.viewTitle.textColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.view.addSubview(self.viewTitle)

        // settings button to change colors and shapes to instruments
        self.settingsButton.frame = CGRect(x: 550, y: 30, width: 120, height: 40)
        self.settingsButton.setTitle("Settings", for: .normal)
        self.settingsButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.settingsButton.titleLabel?.textAlignment = .center
        self.settingsButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.settingsButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2
        self.settingsButton.addTarget(self, action: #selector(HomeViewController.openSettings(sender:)), for: .touchUpInside)
        self.view.addSubview(self.settingsButton)
        
        // segmented control to choose an instrument
        self.instrumentSegmentedControl =
            InstrumentSegmentedControl(frame:CGRect(x: 50, y: 140, width: 600, height: 160),
                                       instruments: self.instruments)
        self.instrumentSegmentedControl.backgroundColor = .clear
        self.instrumentSegmentedControl.delegate = self
        self.view.addSubview(self.instrumentSegmentedControl)
        
        // segmented control to choose game difficulty
        self.difficultySegmentedControl =
            DifficultySegmentedControl(frame: CGRect(x: 125, y: 330, width: 450, height: 50),
                                       levels: DifficultyLevel.levels)
        self.difficultySegmentedControl.backgroundColor = .clear
        self.difficultySegmentedControl.delegate = self
        self.view.addSubview(self.difficultySegmentedControl)
        
        // play button to start the game
        self.playButton.frame = CGRect(x: 275, y: 420, width: 150, height: 50)
        self.playButton.setTitle("Play", for: .normal)
        self.playButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.playButton.titleLabel?.textAlignment = .center
        self.playButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.playButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.playButton.layer.cornerRadius = self.playButton.frame.size.height / 2
        self.playButton.addTarget(self, action: #selector(HomeViewController.playGame(sender:)), for: .touchUpInside)
        self.view.addSubview(self.playButton)
    }

    @objc func openSettings(sender: UIButton) {
        let settingsViewController = SettingsViewController(withInstruments: self.instruments)
        settingsViewController.settingsDelegate = self
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    @objc func playGame(sender: UIButton) {
        let gameViewController = GameViewController(withLevel: self.difficultyLevel, instrument: self.selectedInstrument)
        self.present(gameViewController, animated: true, completion: nil)
    }
 
    private func playSound(forInstrument instrument: Instrument) {
        var filePath: String?
        switch instrument.getType() {
        case .Piano:
            filePath = Bundle.main.path(forResource: "PianoC1", ofType: "wav")
        case .Guitar:
            filePath = Bundle.main.path(forResource: "GuitarC1", ofType: "wav")
        case .Trumpet:
            filePath = Bundle.main.path(forResource: "TrumpetC1", ofType: "wav")
        }
        let soundFileURL = URL(fileURLWithPath: filePath!)
        do{
            self.sound = try AVAudioPlayer(contentsOf: soundFileURL)
            self.sound.volume = 0.6
            self.sound.numberOfLoops = 0
            self.sound.play()
        } catch {
            print("\(error)")
        }
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
        self.playSound(forInstrument: instrument)
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

