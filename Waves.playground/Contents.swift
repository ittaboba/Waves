import UIKit
import PlaygroundSupport

class HomeViewController: UIViewController {
    
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
        
        
    }
}

let homeViewController = HomeViewController()
PlaygroundPage.current.liveView = homeViewController.view

