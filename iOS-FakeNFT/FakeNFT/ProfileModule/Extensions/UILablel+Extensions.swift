//
//  UILablel+Extensions.swift
//  FakeNFT
//
//  Created by Антон Кашников on 14/10/2023.
//

import UIKit

extension UILabel {
    convenience init(text: String) {
        self.init()
        self.text = text
        textColor = .ypBlack
        font = .systemFont(ofSize: 22, weight: .bold)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
