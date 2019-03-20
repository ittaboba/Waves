import UIKit


public class SettingsViewController: UIViewController {
    
    private var instrumentsCollectionView: UICollectionView!
    private let instrumentCellIdentifier = "instrumentCell"
    private var instruments = Settings.shared().getDefaultInstruments()
    
    private var shapesCollectionView: UICollectionView!
    private let shapeCellIdentifier = "shapeCell"
    private var shapes = Settings.shared().getDefaultShapes()
    
    private var longPressGesture: UILongPressGestureRecognizer!
    
    public init() {
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
        self.view.backgroundColor = Settings.shared().getDisplayMode() == .Light ? UIColor.white : UIColor.black
        
        
        let instrumentsCollectionView = UICollectionView(frame: CGRect(x: 85, y: 150, width: 530, height: 120),
                                                   collectionViewLayout: UICollectionViewFlowLayout())
        instrumentsCollectionView.backgroundColor = .clear
        instrumentsCollectionView.isScrollEnabled = false
        self.view.addSubview(instrumentsCollectionView)
        self.instrumentsCollectionView = instrumentsCollectionView
        
        let shapesCollectionView = UICollectionView(frame: CGRect(x: 85, y: 300, width: 530, height: 120),
                                                    collectionViewLayout: UICollectionViewFlowLayout())
        shapesCollectionView.backgroundColor = .clear
        shapesCollectionView.isScrollEnabled = false
        self.view.addSubview(shapesCollectionView)
        self.shapesCollectionView = shapesCollectionView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.instrumentsCollectionView.delegate = self
        self.instrumentsCollectionView.dataSource = self
        self.instrumentsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.instrumentCellIdentifier)
        
        self.shapesCollectionView.delegate = self
        self.shapesCollectionView.dataSource = self
        self.shapesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: self.shapeCellIdentifier)
        
        self.longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(SettingsViewController.handleLongPress(gesture:)))
        self.shapesCollectionView.addGestureRecognizer(self.longPressGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            guard let indexPath = self.shapesCollectionView.indexPathForItem(at: gesture.location(in: self.shapesCollectionView)) else {
                break
            }
            self.shapesCollectionView.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            self.shapesCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            self.shapesCollectionView.endInteractiveMovement()
        default:
            self.shapesCollectionView.cancelInteractiveMovement()
        }
    }
}

extension SettingsViewController: UICollectionViewDataSource {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.instrumentsCollectionView {
            return self.instruments.count
        } else {
            return self.shapes.count
        }
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.instrumentsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.instrumentCellIdentifier, for: indexPath)
            let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
            icon.image = UIImage(named: "icon.png")
            cell.contentView.addSubview(icon)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.shapeCellIdentifier, for: indexPath)
            let shape = self.shapes[indexPath.item]
            let transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            shape.setAffineTransform(transform)
            cell.layer.mask = shape
            cell.layer.backgroundColor = shape.getColor().toRGBColor().cgColor
            return cell
        }
    }
    
}

extension SettingsViewController: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        if collectionView == self.shapesCollectionView {
            return true
        }
        return false
    }
    
    public func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if collectionView == self.shapesCollectionView {
            let shape = self.shapes.remove(at: sourceIndexPath.item)
            self.shapes.insert(shape, at: destinationIndexPath.item)
            Settings.shared().setDefaultShapes(shapes: self.shapes)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.shapesCollectionView {
            let cell = collectionView.cellForItem(at: indexPath)
            
            let colorPaletteCollectionViewController = ColorPaletteCollectionViewController(withShape: self.shapes[indexPath.item])
            colorPaletteCollectionViewController.modalPresentationStyle = .popover
            colorPaletteCollectionViewController.preferredContentSize = CGSize(width: 200, height: 200)
            
            present(colorPaletteCollectionViewController, animated: true, completion: nil)
            
            let popoverPresentationController = colorPaletteCollectionViewController.popoverPresentationController
            popoverPresentationController?.delegate = self
            popoverPresentationController?.sourceView = cell?.contentView
            popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: cell!.contentView.frame.size.width, height: cell!.contentView.frame.size.height)
            
        }
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 85
    }
}

extension SettingsViewController: UIPopoverPresentationControllerDelegate {
    public func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
        print("present")
    }
    
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        print("dismiss")
    }
    
    public func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}
