//
//  OrderUpdateDTO.swift
//  FakeNFT
//
//  Created by Andy Kruch on 17.10.23.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let orderUpdateDTO: OrderUpdateDTO

    var endpoint = URL(string: "\(Config.baseUrl)/orders/1")
    var httpMethod = HttpMethod.put
    
    var dto: Encodable? {
        orderUpdateDTO
    }
}

struct OrderUpdateDTO: Encodable {
    let nfts: [String]
    let id: String
}
