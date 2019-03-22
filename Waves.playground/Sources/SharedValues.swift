import UIKit

// MARK: View
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
    case Window
    
    func get() -> View {
        switch self {
        case .Window:
            return View(x: 0, y: 0, width: 700, height: 500)
        }
    }
}

// MARK: Segmented Control
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
            return SegmentedControl(x: 125, y: 330, width: 450, height: 50)
        case .Instrument:
            return SegmentedControl(x: 50, y: 140, width: 600, height: 160)
        }
    }
}

// MARK: Button
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
    case Settings
    case Dismiss
    
    func get() -> Button {
        switch self {
        case .Play:
            return Button(x: 275, y: 420, width: 150, height: 50, title: "Play")
        case .Settings:
            return Button(x: 550, y: 30, width: 120, height: 40, title: "Settings")
        case .Dismiss:
            return Button(x: 30, y: 30, width: 120, height: 40, title: "Close")
        }
    }
}

// MARK: Label
public struct Label {
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

enum LabelType {
    case HomeTitle
    case SettingsTitle
    
    func get() -> Label {
        switch self {
        case .HomeTitle:
            return Label(x: 200, y: 30, width: 300, height: 100, title: "Waves")
        case .SettingsTitle:
            return Label(x: 200, y: 30, width: 300, height: 100, title: "Settings")
        }
    }
}

// MARK: Font
public struct Font {
    private var name: String
    
    init(name: String) {
        self.name = name
    }
    
    public func getName() -> String {
        return self.name
    }
}

enum FontType {
    case SanFranciscoBold
    case SanFranciscoHeavy
    
    func get() -> Font {
        switch self {
        case .SanFranciscoBold:
            return Font(name: ".SFUIText-Bold")
        case .SanFranciscoHeavy:
            return Font(name: ".SFUIText-Heavy")
        }
    }
}

public class SharedValues {
    
    private static let sharedValues = SharedValues()
    
    public class func shared() -> SharedValues {
        return sharedValues
    }
    
    // views
    private let windowView = ViewType.Window.get()
    public func getWindowView() -> View {
        return self.windowView
    }
    
    // segmented controls
    private let difficultySegmentedControl = SegmentedControlType.Difficulty.get()
    public func getDifficultySegmentedControl() -> SegmentedControl {
        return self.difficultySegmentedControl
    }
    
    private let instrumentSegmentedControl = SegmentedControlType.Instrument.get()
    public func getInstrumentSegmentedControl() -> SegmentedControl {
        return self.instrumentSegmentedControl
    }
    
    // buttons
    private let playButton = ButtonType.Play.get()
    public func getPlayButton() -> Button {
        return self.playButton
    }
    
    private let settingsButton = ButtonType.Settings.get()
    public func getSettingsButton() -> Button {
        return self.settingsButton
    }
    
    private let dismissButton = ButtonType.Dismiss.get()
    public func getDismissButton() -> Button {
        return self.dismissButton
    }
    
    // labels
    private let homeLabelTitle = LabelType.HomeTitle.get()
    public func getHomeLabelTitle() -> Label {
        return self.homeLabelTitle
    }
    
    private let settingsLabelTitle = LabelType.SettingsTitle.get()
    public func getSettingsLabelTitle() -> Label {
        return self.settingsLabelTitle
    }
    
    // fonts
    private let sanFranciscoBoldFont = FontType.SanFranciscoBold.get()
    public func getSanFranciscoBoldFont() -> Font {
        return self.sanFranciscoBoldFont
    }
    
    private let sanFranciscoHeavyFont = FontType.SanFranciscoHeavy.get()
    public func getSanFranciscoHeavyFont() -> Font {
        return self.sanFranciscoHeavyFont
    }
}
