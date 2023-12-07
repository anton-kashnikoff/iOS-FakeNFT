//
//  OrderUpdateDTO.swift
//  FakeNFT
//
//  Created by Andy Kruch on 17.10.23.
//

import Foundation

struct OrderUpdateRequest: NetworkRequest {
    let orderUpdateDTO: OrderUpdateDTO
    var endpoint: URL? {
        URL(string: "https://651ff0e9906e276284c3c24a.mockapi.io/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable? {
        orderUpdateDTO
    }
}

struct OrderUpdateDTO: Encodable {
    let nfts: [String]
    let id: String
}

