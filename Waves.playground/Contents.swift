//: ![](Cover.pdf)

/*
 "Color is the keyboard, the eyes are the harmonies, the soul is the piano with many strings.
 The artist is the hand that plays, touching one key or another, to cause vibrations in the soul."
 [Wassily Kandinsky]
*/

import UIKit
import AVFoundation
import PlaygroundSupport

/**
 Change DisplayMode value to play in Light or Dark mode
 */
private let displayMode = DisplayMode.Dark


public class Button: UIButton {
    public override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        }
    }
}

class HomeViewController: UIViewController {
    private var difficultyLevel: DifficultyLevel = .Easy
    private var selectedInstrument: Instrument = InstrumentFactory.shared().createInstrument(withType: .Piano)
    
    private var instruments = [Instrument]()
    private var instrumentTypes = [InstrumentType]()
    
    private var viewTitle: UILabel!
    
    private let settingsButton = UIButton(type: .custom)
    private let startButton = UIButton(type: .custom)
    
    private let pianoButton = Button(type: .custom)
    private let guitarButton = Button(type: .custom)
    private let trumpetButton = Button(type: .custom)
    
    private let easyButton = Button(type: .custom)
    private let mediumButton = Button(type: .custom)
    private let hardButton = Button(type: .custom)
    
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
        self.viewTitle = UILabel(frame: CGRect(x: 200, y: 30, width: 300, height: 60))
        self.viewTitle.text = "Welcome"
        self.viewTitle.textAlignment = .center
        self.viewTitle.font = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.heavy)
        self.viewTitle.textColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.view.addSubview(self.viewTitle)

        // settings button to change colors and shapes to instruments
        self.settingsButton.frame = CGRect(x: 550, y: 30, width: 120, height: 40)
        self.settingsButton.setTitle("Settings", for: .normal)
        self.settingsButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.settingsButton.titleLabel?.textAlignment = .center
        self.settingsButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.settingsButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2
        self.settingsButton.addTarget(self, action: #selector(HomeViewController.openSettings(sender:)), for: .touchUpInside)
        self.view.addSubview(self.settingsButton)
        
        // piano button
        self.pianoButton.frame = CGRect(x: 50, y: 120, width: 160, height: 160)
        let pianoInstrument = self.instruments[0]
        let pianoShape = pianoInstrument.getType().getShape(withSize: CGSize(width: 160, height: 160))
        self.pianoButton.tag = 0
        self.pianoButton.setImage(pianoInstrument.getIcon(), for: .normal)
        self.pianoButton.imageEdgeInsets = UIEdgeInsets(top: 57.5, left: 50, bottom: 57.5, right: 50)
        self.pianoButton.backgroundColor = pianoShape.getColor().toRGBColor()
        self.pianoButton.layer.mask = pianoShape
        self.pianoButton.isSelected = true
        self.pianoButton.addTarget(self, action: #selector(HomeViewController.instrumentButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.pianoButton)
        
        // guitar button
        self.guitarButton.frame = CGRect(x: 270, y: 120, width: 160, height: 160)
        let guitarInstrument = self.instruments[1]
        let guitarShape = guitarInstrument.getType().getShape(withSize: CGSize(width: 160, height: 160))
        self.guitarButton.tag = 1
        self.guitarButton.setImage(guitarInstrument.getIcon(), for: .normal)
        self.guitarButton.imageEdgeInsets = UIEdgeInsets(top: 57.5, left: 50, bottom: 57.5, right: 50)
        self.guitarButton.backgroundColor = guitarShape.getColor().toRGBColor()
        self.guitarButton.layer.mask = guitarShape
        self.guitarButton.addTarget(self, action: #selector(HomeViewController.instrumentButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.guitarButton)
        
        // trumpet button
        self.trumpetButton.frame = CGRect(x: 490, y: 120, width: 160, height: 160)
        let trumpetInstrument = self.instruments[2]
        let trumpetShape = trumpetInstrument.getType().getShape(withSize: CGSize(width: 160, height: 160))
        self.trumpetButton.tag = 2
        self.trumpetButton.setImage(trumpetInstrument.getIcon(), for: .normal)
        self.trumpetButton.imageEdgeInsets = UIEdgeInsets(top: 57.5, left: 50, bottom: 57.5, right: 50)
        self.trumpetButton.backgroundColor = trumpetShape.getColor().toRGBColor()
        self.trumpetButton.layer.mask = trumpetShape
        self.trumpetButton.addTarget(self, action: #selector(HomeViewController.instrumentButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.trumpetButton)
        
        // easy button
        self.easyButton.frame = CGRect(x: 80, y: 330, width: 150, height: 50)
        self.easyButton.setTitle(DifficultyLevel.Easy.rawValue, for: .normal)
        self.easyButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.easyButton.titleLabel?.textAlignment = .center
        self.easyButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.easyButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        self.easyButton.layer.cornerRadius = self.easyButton.frame.size.height / 2
        self.easyButton.isSelected = true
        self.easyButton.addTarget(self, action: #selector(HomeViewController.difficultyButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.easyButton)
        
        // medium button
        self.mediumButton.frame = CGRect(x: 275, y: 330, width: 150, height: 50)
        self.mediumButton.setTitle(DifficultyLevel.Medium.rawValue, for: .normal)
        self.mediumButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.mediumButton.titleLabel?.textAlignment = .center
        self.mediumButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.mediumButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        self.mediumButton.layer.cornerRadius = self.mediumButton.frame.size.height / 2
        self.mediumButton.addTarget(self, action: #selector(HomeViewController.difficultyButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.mediumButton)
        
        // hard button
        self.hardButton.frame = CGRect(x: 470, y: 330, width: 150, height: 50)
        self.hardButton.setTitle(DifficultyLevel.Hard.rawValue, for: .normal)
        self.hardButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.hardButton.titleLabel?.textAlignment = .center
        self.hardButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.hardButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        self.hardButton.layer.cornerRadius = self.hardButton.frame.size.height / 2
        self.hardButton.addTarget(self, action: #selector(HomeViewController.difficultyButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.hardButton)
        
        // play button to start the game
        self.startButton.frame = CGRect(x: 275, y: 420, width: 150, height: 50)
        self.startButton.setTitle("Start", for: .normal)
        self.startButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.startButton.titleLabel?.textAlignment = .center
        self.startButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.startButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        self.startButton.layer.cornerRadius = self.startButton.frame.size.height / 2
        self.startButton.addTarget(self, action: #selector(HomeViewController.startGame(sender:)), for: .touchUpInside)
        self.view.addSubview(self.startButton)
    }

    @objc func openSettings(sender: UIButton) {
        let settingsViewController = SettingsViewController(withInstruments: self.instruments)
        settingsViewController.settingsDelegate = self
        self.present(settingsViewController, animated: true, completion: nil)
    }
    
    @objc func instrumentButtonPressed(sender: UIButton) {
        var instrumentType: InstrumentType!
        switch sender.tag {
        case 0:
            instrumentType = InstrumentType.Piano
        case 1:
            instrumentType = InstrumentType.Guitar
        case 2:
            instrumentType = InstrumentType.Trumpet
        default:
            return
        }
        
        self.selectedInstrument = self.instruments.first(where: {$0.getType() == instrumentType})!
        self.pianoButton.isSelected = instrumentType == .Piano
        self.guitarButton.isSelected = instrumentType == .Guitar
        self.trumpetButton.isSelected = instrumentType == .Trumpet
        self.playSound(forInstrument: self.selectedInstrument)
        
    }
    
    @objc func difficultyButtonPressed(sender: UIButton) {
        if let title = sender.titleLabel?.text {
            self.difficultyLevel = DifficultyLevel(rawValue: title)!
            self.easyButton.isSelected = self.difficultyLevel == .Easy
            self.mediumButton.isSelected = self.difficultyLevel == .Medium
            self.hardButton.isSelected = self.difficultyLevel == .Hard
        }
    }
    
    @objc func startGame(sender: UIButton) {
        let gameViewController = GameViewController(withLevel: self.difficultyLevel, instrument: self.selectedInstrument)
        self.present(gameViewController, animated: true)
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
        let pianoShape = self.instruments[0].getType().getShape(withSize: CGSize(width: 160, height: 160))
        self.pianoButton.backgroundColor = pianoShape.getColor().toRGBColor()
        self.pianoButton.layer.mask = pianoShape
        
        let guitarShape = self.instruments[1].getType().getShape(withSize: CGSize(width: 160, height: 160))
        self.guitarButton.backgroundColor = guitarShape.getColor().toRGBColor()
        self.guitarButton.layer.mask = guitarShape
        
        let trumpetShape = self.instruments[2].getType().getShape(withSize: CGSize(width: 160, height: 160))
        self.trumpetButton.backgroundColor = trumpetShape.getColor().toRGBColor()
        self.trumpetButton.layer.mask = trumpetShape
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

