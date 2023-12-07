//
//  CornerRadius.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 19.10.2023.
//

import Foundation

enum CornerRadius: Int {
    case big = 16
    case medium = 12
    case small = 6
    
    func cgFloat() -> CGFloat {
        CGFloat(self.rawValue)
    }
}
