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
    
    private var tonesCollectionView: UICollectionView!
    private let tonesCellIdentifier = "tonesCell"
    private var selectedTone: Tone?
    private var tones = [Tone]()
    
    private var placeholdersCollectionView: UICollectionView!
    private let placeholdersCellIdentifier = "placeholdersCell"
    private var placeholders = [Tone]()
    
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
        
        // create tones for notes
        self.instrument = InstrumentFactory.shared().createInstrument(withType: instrumentType)
        for i in 0 ..< allNotes.count {
            let tone = Tone(withFrame: CGRect(x: 0, y: 0, width: 50, height: 50),
                            instrument: self.instrument,
                            note: allNotes[i],
                            engine: self.engine)
            self.tones.append(tone)
        }
        
        // create tones for placeholders
        for _ in 0 ..< 6 {
            let placeholder = Tone(withFrame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                   instrument: self.instrument,
                                   note: nil,
                                   engine: self.engine)
            self.placeholders.append(placeholder)
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
            self.tones[indexPath.item].play()
        } else {
            if self.placeholders[indexPath.item].isPlaceholder() {
                if let tone = self.selectedTone {
                    let newTone = tone.clone()
                    self.placeholders[indexPath.item] = newTone
                }
            } else {
                let newPlaceholder = Tone(withFrame: CGRect(x: 0, y: 0, width: 50, height: 50),
                                          instrument: self.instrument,
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
        if collectionView == self.tonesCollectionView {
            let verticalMargin = CGFloat(20) * CGFloat(5 - self.tones.count / 7)
            let horizontalMargin = CGFloat(60)
            return UIEdgeInsets(top: verticalMargin, left: horizontalMargin, bottom: verticalMargin, right: horizontalMargin)
        } else {
            return UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}
