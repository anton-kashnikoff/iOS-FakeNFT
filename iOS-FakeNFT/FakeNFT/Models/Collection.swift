//
//  Collection.swift
//  FakeNFT
//
//  Created by Andy Kruch on 09.10.23.
//

struct Collection: Decodable {
    let createdAt: String
    let name: String
    let cover: String?
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
