import UIKit

public class VictoryViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func loadView() {
        self.view = UIView(frame: CGRect(x: SharedValues.shared().getWindowView().getX(),
                                         y: SharedValues.shared().getWindowView().getY(),
                                         width: SharedValues.shared().getWindowView().getWidth(),
                                         height: SharedValues.shared().getWindowView().getHeight()))
        self.view.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .white : .black
        
        let icon = UIImageView(frame: CGRect(x: 300, y: 100, width: 100, height: 200))
        icon.image = UIImage(named: "VictoryIcon.png")
        icon.image = icon.image?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        self.view.addSubview(icon)
        
        let message = UILabel(frame: CGRect(x: 150, y: 300, width: 400, height: 100))
        message.text = "You won!"
        message.textColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        message.textAlignment = .center
        message.font = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.heavy)
        self.view.addSubview(message)
        
        let dismissButton = UIButton(frame: CGRect(x: SharedValues.shared().getDismissButton().getX(),
                                          y: SharedValues.shared().getDismissButton().getY(),
                                          width: SharedValues.shared().getDismissButton().getWidth(),
                                          height: SharedValues.shared().getDismissButton().getHeight()))
        dismissButton.setTitle(SharedValues.shared().getDismissButton().getTitle(), for: .normal)
        dismissButton.backgroundColor = Settings.shared().getDisplayMode() == .Light ? .black : .white
        dismissButton.titleLabel?.textAlignment = .center
        dismissButton.setTitleColor(Settings.shared().getDisplayMode() == .Light ? .white : .black, for: .normal)
        dismissButton.titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: UIFont.Weight.bold)
        dismissButton.layer.cornerRadius = SharedValues.shared().getDismissButton().getHeight() / 2
        dismissButton.addTarget(self, action: #selector(VictoryViewController.dismissView(sender:)), for: .touchUpInside)
        self.view.addSubview(dismissButton)
    }
    
    @objc func dismissView(sender: UIButton) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

