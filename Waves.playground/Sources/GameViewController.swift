import UIKit
import AVFoundation


public class ToneCollectionViewCell: UICollectionViewCell {
    public override var isSelected: Bool {
        didSet {
            if self.isSelected {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        }
    }
}

public class GameViewController: UIViewController {
    
    private let engine = AVAudioEngine()
    
    private var instrument: Instrument!
    
    private var levelNotes = [Note]()
    private var solution = [Tone]()
    
    private var tonesCollectionView: UICollectionView!
    private let tonesCellIdentifier = "tonesCell"
    private var selectedTone: Tone?
    private var tones = [Tone]()
    
    private var placeholdersCollectionView: UICollectionView!
    private let placeholdersCellIdentifier = "placeholdersCell"
    private var placeholders = [Tone]()
    
    private let dismissButton = UIButton(type: .custom)
    private let listenButton = UIButton(type: .custom)
    private let playButton = UIButton(type: .custom)
    private let solutionButton = UIButton(type: .custom)
    
    private var attemptsRemaining = 0
    
    public init(withLevel level: DifficultyLevel, instrument: Instrument) {
        let gameDifficulty = DifficultyManager()
        var allNotes = [Note]()
        
        self.instrument = instrument
        
        // set level notes based on difficulty
        switch level {
        case .Easy:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Easy())
            self.attemptsRemaining = 10
            allNotes = Pitch.shared.getNotes(forOctaves: .one)
        case .Medium:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Medium())
            self.attemptsRemaining = 6
            allNotes = Pitch.shared.getNotes(forOctaves: .two)
        case .Hard:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Hard())
            self.attemptsRemaining = 3
            allNotes = Pitch.shared.getNotes(forOctaves: .two)
        }
        
        // create tones for solution
        for note in self.levelNotes {
            let tone = Tone(withInstrument: self.instrument,
                            note: note,
                            engine: self.engine)
            self.solution.append(tone)
        }
        
        // create tones for notes
        for i in 0 ..< allNotes.count {
            let tone = Tone(withInstrument: self.instrument,
                            note: allNotes[i],
                            engine: self.engine)
            self.tones.append(tone)
        }
        
        // create tones for placeholders
        for _ in 0 ..< self.levelNotes.count {
            let tone = Tone(withInstrument: self.instrument,
                                   note: nil,
                                   engine: self.engine)
            self.placeholders.append(tone)
        }
        
        // set engine
        self.engine.prepare()
        try! engine.start()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func loadView() {
        // main view
        self.view = UIView(frame: CGRect(x: SharedValues.shared().getGameView().getX(),
                                         y: SharedValues.shared().getGameView().getY(),
                                         width: SharedValues.shared().getGameView().getWidth(),
                                         height: SharedValues.shared().getGameView().getHeight()))
        self.view.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black
        
        // placeholders collection view
        let placeholdersCollectionView = UICollectionView(frame: CGRect(x: 50, y: 100, width: 600, height: 90),
                                                          collectionViewLayout: UICollectionViewFlowLayout())
        placeholdersCollectionView.backgroundColor = .clear
        self.view.addSubview(placeholdersCollectionView)
        self.placeholdersCollectionView = placeholdersCollectionView
        
        // tones collection view
        let tonesCollectionView = UICollectionView(frame: CGRect(x: 50, y: 260, width: 600, height: 240),
                                                   collectionViewLayout: UICollectionViewFlowLayout())
        tonesCollectionView.backgroundColor = .clear
        self.view.addSubview(tonesCollectionView)
        self.tonesCollectionView = tonesCollectionView
        
        // dismiss button
        self.dismissButton.frame = CGRect(x: SharedValues.shared().getDismissButton().getX(),
                                          y: SharedValues.shared().getDismissButton().getY(),
                                          width: SharedValues.shared().getDismissButton().getWidth(),
                                          height: SharedValues.shared().getDismissButton().getHeight())
        self.dismissButton.setTitle(SharedValues.shared().getDismissButton().getTitle(), for: .normal)
        self.dismissButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.dismissButton.titleLabel?.textAlignment = .center
        self.dismissButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        self.dismissButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.dismissButton.layer.cornerRadius = SharedValues.shared().getDismissButton().getHeight() / 2
        self.dismissButton.addTarget(self, action: #selector(GameViewController.dismissGame(sender:)), for: .touchUpInside)
        self.view.addSubview(self.dismissButton)
        
        // icon
        let gameIcon = UIImageView(frame: CGRect(x: 200, y: 30, width: 80, height: 60))
        gameIcon.image = self.instrument.getIcon()
        gameIcon.image = gameIcon.image?.withRenderingMode(.alwaysTemplate)
        gameIcon.tintColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.view.addSubview(gameIcon)
        
        // title
        let gameTitle = UILabel(frame: CGRect(x: 300, y: 30, width: 300, height: 60))
        gameTitle.text = self.instrument.getType().rawValue
        gameTitle.textAlignment = .left
        gameTitle.textColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        gameTitle.font = UIFont(name: SharedValues.shared().getSanFranciscoHeavyFont().getName(), size: 60)
        gameTitle.backgroundColor = .clear
        self.view.addSubview(gameTitle)
        
        // listen button
        self.listenButton.frame = CGRect(x: 75, y: 200, width: 150, height: 50)
        self.listenButton.setTitle("Listen (\(self.attemptsRemaining))", for: .normal)
        self.listenButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white
        self.listenButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black, for: .normal)
        self.listenButton.layer.cornerRadius = self.listenButton.frame.size.height/2
        self.listenButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.listenButton.addTarget(self, action: #selector(GameViewController.listenButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.listenButton)
        
        // play button
        self.playButton.frame = CGRect(x: 275, y: 200, width: 150, height: 50)
        self.playButton.setTitle("Play", for: .normal)
        self.playButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white
        self.playButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black, for: .normal)
        self.playButton.layer.cornerRadius = self.playButton.frame.size.height/2
        self.playButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.playButton.addTarget(self, action: #selector(GameViewController.playButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.playButton)
        
        // solution button
        self.solutionButton.frame = CGRect(x: 475, y: 200, width: 150, height: 50)
        self.solutionButton.setTitle("Solution", for: .normal)
        self.solutionButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white
        self.solutionButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black, for: .normal)
        self.solutionButton.layer.cornerRadius = self.solutionButton.frame.size.height/2
        self.solutionButton.titleLabel?.font = UIFont(name: SharedValues.shared().getSanFranciscoBoldFont().getName(), size: 22)
        self.solutionButton.addTarget(self, action: #selector(GameViewController.solutionButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.solutionButton)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeholdersCollectionView.delegate = self
        self.placeholdersCollectionView.dataSource = self
        self.placeholdersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.placeholdersCellIdentifier)
        
        self.tonesCollectionView.delegate = self
        self.tonesCollectionView.dataSource = self
        self.tonesCollectionView.register(ToneCollectionViewCell.self, forCellWithReuseIdentifier: self.tonesCellIdentifier)
    }
    
    @objc func dismissGame(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func listenButtonPressed(sender: UIButton) {
        if self.attemptsRemaining == 0 {
            self.showDefeatMessage()
        } else {
            self.lockButtons()
            self.attemptsRemaining -= 1
            self.listenButton.setTitle("Listen (\(self.attemptsRemaining))", for: .normal)
            self.play(tones: self.solution, atIndex: 0, isSolution: false)
        }
    }
    
    @objc func playButtonPressed(sender: UIButton) {
        self.lockButtons()
        self.play(tones: self.placeholders, atIndex: 0, isSolution: false)
    }
    
    @objc func solutionButtonPressed(sender: UIButton) {
        self.lockButtons()
        self.placeholders = self.solution
        self.placeholdersCollectionView.reloadData()
        self.placeholdersCollectionView.allowsSelection = false
        self.play(tones: self.placeholders, atIndex: 0, isSolution: true)
    }
    
    private func play(tones: [Tone], atIndex index: Int, isSolution: Bool) {
        if index == tones.count && isSolution {
            return
        } else if index == tones.count {
            self.unlockButtons()
            if self.victoryCheck() {
                self.showVictoryMessage()
            }
            return
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                tones[index].transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            })
            tones[index].play(didFinish: {
                DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                    UIView.animate(withDuration: 0.2, animations: {
                        tones[index].transform = CGAffineTransform.identity
                    })
                    self.play(tones: tones, atIndex: index + 1, isSolution: isSolution)
                })
            })
        }
    }
    
    private func lockButtons() {
        self.listenButton.isEnabled = false
        self.listenButton.backgroundColor = .gray
        
        self.playButton.isEnabled = false
        self.playButton.backgroundColor = .gray
        
        self.solutionButton.isEnabled = false
        self.solutionButton.backgroundColor = .gray
    }
    
    private func unlockButtons() {
        self.listenButton.isEnabled = true
        self.listenButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white
        
        self.playButton.isEnabled = true
        self.playButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white
        
        self.solutionButton.isEnabled = true
        self.solutionButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.black : UIColor.white
    }

    private func victoryCheck() -> Bool {
        for i in 0 ..< self.solution.count {
            if self.solution[i].getNote()?.rawValue != self.placeholders[i].getNote()?.rawValue {
                return false
            }
        }
        return true
    }
    
    private func showVictoryMessage() {
        print("victory")
    }
    
    private func showDefeatMessage() {
        print("defeat")
    }
}

extension GameViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.tonesCollectionView {
            return self.tones.count
        } else {
            return self.placeholders.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.tonesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.tonesCellIdentifier, for: indexPath) as! ToneCollectionViewCell
            cell.contentView.addSubview(self.tones[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.placeholdersCellIdentifier, for: indexPath)
            cell.contentView.addSubview(self.placeholders[indexPath.item])
            return cell
        }
    }
}

extension GameViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.tonesCollectionView {
            self.selectedTone = self.tones[indexPath.item]
            self.tones[indexPath.item].play(didFinish: nil)
        } else {
            if self.placeholders[indexPath.item].isPlaceholder() {
                if let tone = self.selectedTone {
                    let newTone = tone.clone()
                    self.placeholders[indexPath.item] = newTone
                }
            } else {
                let newPlaceholder = Tone(withInstrument: self.instrument,
                                          note: nil,
                                          engine: self.engine)
                self.placeholders[indexPath.item] = newPlaceholder
            }
            self.placeholdersCollectionView.reloadData()
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let horizontalMargin = CGFloat(20)
        
        if collectionView == self.tonesCollectionView {
            let numOfLines = Int(self.tones.count / 7)
            let verticalMargin = (collectionView.frame.size.height - CGFloat(50 * numOfLines) - CGFloat(20 * (numOfLines - 1)))/CGFloat(2)
            return UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        } else {
            return UIEdgeInsets(top: 20, left: horizontalMargin, bottom: 20, right: horizontalMargin)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 35
    }
}
