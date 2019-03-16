import UIKit

public class Tone: UIView {
    
    private var note: Note?
    private var instrument: Instrument
    
    public init(withFrame frame: CGRect, note: Note?, instrument: Instrument) {
        self.note = note
        self.instrument = instrument
        
        super.init(frame: frame)
        
        if let n = note {
            let instrumentHue = instrument.getType().getShape().getColor().getHue()
            
            let allNotes = Pitch.shared.getNotes(forOctaves: .four)
            
            if let index = allNotes.firstIndex(of: n) {
                let octave = CGFloat(index/7 + 1)
                let octaveNote = CGFloat(index % 7)
                
                let saturation = CGFloat(100 - octave * 20)
                let value = CGFloat(100 - octaveNote * 10)
                
                let toneColor = Color(hue: instrumentHue, saturation: saturation, value: value)
                
                self.backgroundColor = toneColor.toRGBColor()
            }
        } else {
            self.backgroundColor = .gray
        }
        
        self.setMask(forShape: instrument.getType().getShape(), size: frame.size)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setMask(forShape shape: Shape, size: CGSize) {
        print(shape)
        if shape is Circle {
            let newShape = shape as! Circle
            newShape.setDiameter(diameter: size.width)
            self.layer.mask = newShape
        } else if shape is Square {
            let newShape = shape as! Square
            newShape.setSize(size: size)
            self.layer.mask = newShape
        } else if shape is Triangle {
            let newShape = shape as! Triangle
            newShape.setSize(size: size)
            self.layer.mask = newShape
        }
    }
    
    public func isPlaceholder() -> Bool {
        if let _ = self.note {
            return false
        }
        
        return true
    }
    
    public func clone() -> Tone {
        return Tone(withFrame: self.frame, note: self.note, instrument: self.instrument)
    }
}
