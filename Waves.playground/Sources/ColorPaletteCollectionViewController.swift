import UIKit

public protocol ColorPaletteDelegate: class {
    func didSelectColor(color: Color)
}

public class ColorPaletteCollectionViewController: UICollectionViewController {
    
    private var colorsCollectionView: UICollectionView!
    private let colorCellIdentifier = "colorCell"
    private var colors = Settings.shared().getDefaultColors()
    
    private var instrument: Instrument!
    
    public weak var paletteDelegate: ColorPaletteDelegate?
    
    public init(withInstrument instrument: Instrument) {
        self.instrument = instrument
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func loadView() {
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200),
                                               collectionViewLayout: UICollectionViewFlowLayout())
        self.collectionView.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.colorCellIdentifier)
    }
    
    // MARK: Data source
    override public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.colorCellIdentifier, for: indexPath)
        let shape = self.instrument.getType().getShape(withSize: CGSize(width: 50, height: 50))        
        cell.layer.mask = shape
        cell.layer.backgroundColor = self.colors[indexPath.item].toRGBColor().cgColor
        
        return cell
    }
    
    // MARK: Delegate
    override public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let color = self.colors[indexPath.item]
        self.dismiss(animated: true, completion: {
            self.paletteDelegate?.didSelectColor(color: color)
        })
    }
        
}

extension ColorPaletteCollectionViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

