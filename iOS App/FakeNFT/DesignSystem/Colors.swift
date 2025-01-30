import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hexString = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        var int = UInt64()
        
        Scanner(string: hexString).scanHexInt64(&int)
        
        let (alpha, red, green, blue): (UInt64, UInt64, UInt64, UInt64) = switch hexString.count {
        case 3: // RGB (12-bit)
            (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (255, 0, 0, 0)
        }
        
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // Primary Colors
    static let ypBlack = UIColor(named: "Black") ?? .black
    static let ypLightGrey = UIColor(named: "ypLightGray") ?? .lightGray
    static let ypWhite = UIColor(named: "White") ?? .white
    static let alertColor = UIColor(named: "AlertColor") ?? .lightGray

    // Universal Colors
    static let backgroundUniversal = UIColor(named: "Background Universal") ?? .gray
    static let blackUniversal = UIColor(named: "Black Universal") ?? .black
    static let blueUniversal = UIColor(named: "Blue Universal") ?? .blue
    static let grayUniversal = UIColor(named: "Gray Universal") ?? .darkGray
    static let greenUniversal = UIColor(named: "Green Universal") ?? .green
    static let redUniversal = UIColor(named: "Red Universal") ?? .red
    static let whiteUniversal = UIColor(named: "White Universal") ?? .white
    static let yellowUniversal = UIColor(named: "Yellow Universal") ?? .yellow
}
