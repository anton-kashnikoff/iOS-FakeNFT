//
//  CollectionShortModel.swift
//  FakeNFT
//
//  Created by Andy Kruch on 18.10.23.
//

struct UserCollection {
    let name: String
    let website: String
    let id: String
    
    init(with user: User) {
        name = user.name
        website = user.website
        id = user.id
    }
}

struct OrderCollection {
    let nfts: [String]
    let id: String
    
    init(with nft: Order) {
        nfts = nft.nfts
        id = nft.id
    }
}
