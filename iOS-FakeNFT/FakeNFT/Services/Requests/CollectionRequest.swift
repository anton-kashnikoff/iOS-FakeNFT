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
            URL(string: "\(Config.baseUrl)/collections")
        case .profile:
            URL(string: "\(Config.baseUrl)/profile/1")
        case .order:
            URL(string: "\(Config.baseUrl)/orders/1")
        case .nft:
            URL(string: "\(Config.baseUrl)/nft")
        case .userId(let userId):
            URL(string: "\(Config.baseUrl)/users/\(userId)")
        }
    }
}
