import UIKit

public struct View {
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
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
}

enum ViewType {
    case Home
    case Game
    
    func get() -> View {
        switch self {
        case .Home:
            return View(x: 0, y: 0, width: 700, height: 500)
        case .Game:
            return View(x: 0, y: 0, width: 700, height: 500)
        }
    }
}

public struct SegmentedControl {
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
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
}

enum SegmentedControlType {
    case Difficulty
    case Instrument
    
    func get() -> SegmentedControl {
        switch self {
        case .Difficulty:
            return SegmentedControl(x: 125, y: 280, width: 450, height: 50)
        case .Instrument:
            return SegmentedControl(x: 50, y: 80, width: 600, height: 160)
        }
    }
}

public struct Button {
    private var x: CGFloat
    private var y: CGFloat
    private var width: CGFloat
    private var height: CGFloat
    private var title: String
    
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, title: String) {
        self.x = x
        self.y = y
        self.width = width
        self.height = height
        self.title = title
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
    
    public func getTitle() -> String {
        return self.title
    }
}

enum ButtonType {
    case Play
    
    func get() -> Button {
        switch self {
        case .Play:
            return Button(x: 275, y: 400, width: 150, height: 50, title: "Play")
        }
    }
}

public class SharedValues {
    
    private static let sharedValues = SharedValues()
    
    public class func shared() -> SharedValues {
        return sharedValues
    }
    
    private let homeView = ViewType.Home.get()
    public func getHomeView() -> View {
        return self.homeView
    }
    
    private let gameView = ViewType.Game.get()
    public func getGameView() -> View {
        return self.gameView
    }
    
    private let difficultySegmentedControl = SegmentedControlType.Difficulty.get()
    public func getDifficultySegmentedControl() -> SegmentedControl {
        return self.difficultySegmentedControl
    }
    
    private let instrumentSegmentedControl = SegmentedControlType.Instrument.get()
    public func getInstrumentSegmentedControl() -> SegmentedControl {
        return self.instrumentSegmentedControl
    }
    
    private let playButton = ButtonType.Play.get()
    public func getPlayButton() -> Button {
        return self.playButton
    }
}
