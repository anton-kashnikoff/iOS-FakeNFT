//
//  OrderPaymentStatus.swift
//  FakeNFT
//
//  Created by Andy Kruch on 10.10.23.
//

struct OrderPaymentStatus: Codable {
    let success: Bool
    let id: String
    let orderId: String
}
