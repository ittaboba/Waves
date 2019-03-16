import UIKit

public class Tone: UIView {
    
    private var note: Note
    private var instrument: Instrument
    
    public init(withFrame frame: CGRect, note: Note, instrument: Instrument) {
        self.note = note
        self.instrument = instrument
        
        super.init(frame: frame)
        
        self.backgroundColor = instrument.getType().getShape().getColor()
        self.setMask(forShape: instrument.getType().getShape())
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMask(forShape shape: Shape) {
        if shape is Circle {
            self.layer.mask = shape as! Circle
        } else if shape is Square {
            self.layer.mask = shape as! Square
        } else if shape is Triangle {
            self.layer.mask = shape as! Triangle
        }
    }
}
