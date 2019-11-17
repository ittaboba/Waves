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
    case Dismiss
    
    func get() -> Button {
        switch self {
        case .Dismiss:
            return Button(x: 30, y: 30, width: 120, height: 40, title: "Close")
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
    
    
    // buttons
    private let dismissButton = ButtonType.Dismiss.get()
    public func getDismissButton() -> Button {
        return self.dismissButton
    }
    
}
