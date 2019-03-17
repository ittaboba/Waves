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
    
    private let listenButton = UIButton(type: .custom)
    private let playButton = UIButton(type: .custom)
    private let solutionButton = UIButton(type: .custom)
    
    public init(withLevel level: DifficultyLevel, instrumentType: InstrumentType) {
        let gameDifficulty = DifficultyManager()
        var allNotes = [Note]()
        
        // set level notes based on difficulty
        switch level {
        case .Easy:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Easy())
            allNotes = Pitch.shared.getNotes(forOctaves: .one)
        case .Medium:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Medium())
            allNotes = Pitch.shared.getNotes(forOctaves: .two)
        case .Hard:
            self.levelNotes = gameDifficulty.setGame(withDifficultyLevel: Hard())
            allNotes = Pitch.shared.getNotes(forOctaves: .four)
        }
        
        self.instrument = InstrumentFactory.shared().createInstrument(withType: instrumentType)
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
        self.view.backgroundColor = SharedValues.shared().getGameView().getBackgroundColor()
        
        // tones collection view
        let tonesCollectionView = UICollectionView(frame: CGRect(x: 50, y: 200, width: 600, height: 300),
                                                   collectionViewLayout: UICollectionViewFlowLayout())
        tonesCollectionView.backgroundColor = .black
        self.view.addSubview(tonesCollectionView)
        self.tonesCollectionView = tonesCollectionView
        
        // placeholders collection view
        let placeholdersCollectionView = UICollectionView(frame: CGRect(x: 50, y: 50, width: 600, height: 100),
                                                           collectionViewLayout: UICollectionViewFlowLayout())
        placeholdersCollectionView.backgroundColor = .brown
        self.view.addSubview(placeholdersCollectionView)
        self.placeholdersCollectionView = placeholdersCollectionView
        
        // listen button
        self.listenButton.frame = CGRect(x: 75, y: 150, width: 150, height: 50)
        self.listenButton.setTitle("Listen", for: .normal)
        self.listenButton.backgroundColor = .red
        self.listenButton.layer.cornerRadius = 25
        self.listenButton.addTarget(self, action: #selector(GameViewController.listenButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.listenButton)
        
        // play button
        self.playButton.frame = CGRect(x: 275, y: 150, width: 150, height: 50)
        self.playButton.setTitle("Play", for: .normal)
        self.playButton.backgroundColor = .red
        self.playButton.layer.cornerRadius = 25
        self.playButton.addTarget(self, action: #selector(GameViewController.playButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.playButton)
        
        // solution button
        self.solutionButton.frame = CGRect(x: 475, y: 150, width: 150, height: 50)
        self.solutionButton.setTitle("Solution", for: .normal)
        self.solutionButton.backgroundColor = .red
        self.solutionButton.layer.cornerRadius = 25
        self.solutionButton.addTarget(self, action: #selector(GameViewController.solutionButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(self.solutionButton)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tonesCollectionView.delegate = self
        self.tonesCollectionView.dataSource = self
        self.tonesCollectionView.register(ToneCollectionViewCell.self, forCellWithReuseIdentifier: self.tonesCellIdentifier)
        
        self.placeholdersCollectionView.delegate = self
        self.placeholdersCollectionView.dataSource = self
        self.placeholdersCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.placeholdersCellIdentifier)
    }
    
    @objc func listenButtonPressed(sender: UIButton) {
        self.lockButtons()
        self.play(tones: self.solution, atIndex: 0, isSolution: false)
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
        self.listenButton.backgroundColor = .black
        
        self.playButton.isEnabled = false
        self.playButton.backgroundColor = .black
        
        self.solutionButton.isEnabled = false
        self.solutionButton.backgroundColor = .black
    }
    
    private func unlockButtons() {
        self.listenButton.isEnabled = true
        self.listenButton.backgroundColor = .red
        
        self.playButton.isEnabled = true
        self.playButton.backgroundColor = .red
        
        self.solutionButton.isEnabled = true
        self.solutionButton.backgroundColor = .red
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
        let horizontalMargin = CGFloat(60)
        
        if collectionView == self.tonesCollectionView {
            let verticalMargin = CGFloat(20) * CGFloat(5 - self.tones.count / 7)
            return UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        } else {
            return UIEdgeInsets(top: 20, left: horizontalMargin, bottom: 20, right: horizontalMargin)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
