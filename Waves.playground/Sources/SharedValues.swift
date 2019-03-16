import UIKit

public struct View {
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    private var backgroundColor: UIColor
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, backgroundColor: UIColor) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.backgroundColor = backgroundColor
    }
    
    public func getX() -> CGFloat {
        return self.x
    }
    
    public func getY() -> CGFloat {
        return self.y
    }
    
    public func getWidth() -> CGFloat {
        return self.width
    }
    
    public func getHeight() -> CGFloat {
        return self.height
    }
    
    public func getBackgroundColor() -> UIColor {
        return self.backgroundColor
    }
}

enum ViewType {
    case Home
    case Game
    
    func get() -> View {
        switch self {
        case .Home:
            return View(x: 0, y: 0, width: 800, height: 500, backgroundColor: .white)
        case .Game:
            return View(x: 0, y: 0, width: 800, height: 500, backgroundColor: .white)
        }
    }
}

public class SharedValues {
    
    public static let shared = SharedValues()
    
    private let homeView = ViewType.Home.get()
    public func getHomeView() -> View {
        return self.homeView
    }
    
    private let gameView = ViewType.Game.get()
    public func getGameView() -> View {
        return self.gameView
    }
}
