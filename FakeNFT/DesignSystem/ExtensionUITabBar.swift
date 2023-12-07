//
//  ExtensionUITabBar.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 30.10.2023.
//

import UIKit

extension UITabBar {
    open override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        
        let subviewClass = String(describing: type(of: subview))
        if subviewClass.lowercased().localizedStandardContains("background") {
            subview.isHidden = true
        }
    }
}
