import UIKit

extension UIFont {
    // Bold Fonts
    enum Bold {
        static let small = UIFont(name: "SF Pro Text Bold", size: 17)
        static let medium = UIFont(name: "SF Pro Text Bold", size: 22)
        static let large = UIFont(name: "SF Pro Text Bold", size: 32)
        static let xlarge = UIFont(name: "SF Pro Text Bold", size: 34)
    }
    
    // Regular fonts
    enum Regular {
        static let small = UIFont(name: "SF Pro Text Regular", size: 13)
        static let medium = UIFont(name: "SF Pro Text Regular", size: 15)
        static let large = UIFont(name: "SF Pro Text Regular", size: 17)
    }
    
    // Medium Fonts
    enum Medium {
        static let medium = UIFont(name: "SF Pro Text Medium", size: 10)
    }
}
