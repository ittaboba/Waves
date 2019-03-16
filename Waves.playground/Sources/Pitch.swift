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
    case D3 = 2600
    case E3 = 2800
    case F3 = 2900
    case G3 = 3100
    case A3 = 3300
    case B3 = 3500
    case C4 = 3600
    case D4 = 3800
    case E4 = 4000
    case F4 = 4100
    case G4 = 4300
    case A4 = 4500
    case B4 = 4700
}

public enum Octaves {
    case one
    case two
    case three
    case four
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
        case .three:
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
                .B2,
                .C3,
                .D3,
                .E3,
                .F3,
                .G3,
                .A3,
                .B3
            ]
        case .four:
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
                .B2,
                .C3,
                .D3,
                .E3,
                .F3,
                .G3,
                .A3,
                .B3,
                .C4,
                .D4,
                .E4,
                .F4,
                .G4,
                .A4,
                .B4
            ]
        }
    }
    
}
