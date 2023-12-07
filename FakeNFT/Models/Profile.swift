//
//  Profile.swift
//  FakeNFT
//
//  Created by Andy Kruch on 10.10.23.
//

import Foundation

struct Profile: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}
