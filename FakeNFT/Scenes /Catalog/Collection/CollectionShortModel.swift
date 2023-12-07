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
        self.name = user.name
        self.website = user.website
        self.id = user.id
    }
}

struct OrderCollection {
    let nfts: [String]
    let id: String
    
    init(with nft: Order) {
        self.nfts = nft.nfts
        self.id = nft.id
    }
}
