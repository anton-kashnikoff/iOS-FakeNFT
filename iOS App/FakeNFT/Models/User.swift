//
//  User.swift
//  FakeNFT
//
//  Created by Andy Kruch on 10.10.23.
//

struct User: Codable {
    let avatar: String
    let name: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
