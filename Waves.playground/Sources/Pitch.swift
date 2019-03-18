public enum Note: Float {
    case C = 0
    case D = 200
    case E = 400
    case F = 500
    case G = 700
    case A = 900
    case B = 1100
    case C2 = 1200
    case D2 = 1400
    case E2 = 1600
    case F2 = 1700
    case G2 = 1900
    case A2 = 2100
    case B2 = 2300
    case C3 = 2400
}

public enum Octaves {
    case one
    case two
}
 
public class Pitch {
    
    public static let shared = Pitch()
    
    public func getNotes(forOctaves octaves: Octaves) -> [Note] {
        switch octaves {
        case .one:
            return [
                .C,
                .D,
                .E,
                .F,
                .G,
                .A,
                .B
            ]
        case .two:
            return [
                .C,
                .D,
                .E,
                .F,
                .G,
                .A,
                .B,
                .C2,
                .D2,
                .E2,
                .F2,
                .G2,
                .A2,
                .B2
            ]
        }
    }
    
}
