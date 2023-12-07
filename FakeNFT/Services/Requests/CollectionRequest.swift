//
//  CatalogRequest.swift
//  FakeNFT
//
//  Created by Andy Kruch on 14.10.23.
//

import Foundation

enum CollectionRequests: NetworkRequest {
    case collection
    case profile
    case order
    case nft
    case userId(userId: String)
    
    var endpoint: URL? {
        switch self {
        case .collection:
            return URL(string: "https://651ff0e9906e276284c3c24a.mockapi.io/api/v1/collections")
        case .profile:
            return URL(string: "https://651ff0e9906e276284c3c24a.mockapi.io/api/v1/profile/1")
        case .order:
            return URL(string: "https://651ff0e9906e276284c3c24a.mockapi.io/api/v1/orders/1")
        case .nft:
            return URL(string: "https://651ff0e9906e276284c3c24a.mockapi.io/api/v1/nft")
        case .userId(userId: let userId):
            return URL(string: "https://651ff0e9906e276284c3c24a.mockapi.io/api/v1/users/\(userId)")
        
        }
    }
}
