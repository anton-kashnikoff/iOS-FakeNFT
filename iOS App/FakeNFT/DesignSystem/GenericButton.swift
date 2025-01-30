//
//  GenericButton.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 19.10.2023.
//

import UIKit

final class GenericButton: UIButton {
    // MARK: - UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .ypBlack
        tintColor = .ypWhite
        clipsToBounds = true
        layer.cornerRadius = CornerRadius.medium.rawValue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
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

@available(iOS 17, *)
#Preview {
    let payButton = GenericButton(type: .system)
    payButton.setTitle("К оплате", for: .normal)
    payButton.titleLabel?.font = .Bold.small
    payButton.layer.cornerRadius = CornerRadius.big.rawValue
    return payButton
}
