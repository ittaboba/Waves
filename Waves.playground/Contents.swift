import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
    private var difficultyLevel: DifficultyLevel = .Easy
    
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
        
        let difficultySegmentedControl = DifficultySegmentedControl(frame: CGRect(x: 250, y: 50, width: 300, height: 40),
                                                          levels: DifficultyLevel.levels)
        difficultySegmentedControl.delegate = self
        self.view.addSubview(difficultySegmentedControl)
    }
}

extension HomeViewController: DifficultySegmentedControlDelegate {
    func difficultyLevelChanged(level: DifficultyLevel) {
        self.difficultyLevel = level
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

