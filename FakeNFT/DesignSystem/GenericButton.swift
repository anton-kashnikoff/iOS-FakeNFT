//
//  GenericButton.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 19.10.2023.
//

import UIKit

final class GenericButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .ypBlack
        self.tintColor = .ypWhite
        self.clipsToBounds = true
        self.layer.cornerRadius = CornerRadius.medium.cgFloat()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func switchActiveState(isActive: Bool) {
        if isActive {
            isUserInteractionEnabled = true
            alpha = 1
        } else {
            isUserInteractionEnabled = false
            alpha = 0.5
        }
    }
}
