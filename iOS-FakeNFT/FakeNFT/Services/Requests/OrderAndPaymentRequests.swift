//
//  OrderAndPaymentRequests.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 22.10.2023.
//

import Foundation

struct CartRequest: NetworkRequest {
    var endpoint: URL?
}

struct CartChangeRequest: NetworkRequest {
    let orderUpdateDTO: OrderUpdateDTO
    
    var endpoint: URL?
    var httpMethod = HttpMethod.put
    var dto: Encodable? {
        orderUpdateDTO
    }
}
