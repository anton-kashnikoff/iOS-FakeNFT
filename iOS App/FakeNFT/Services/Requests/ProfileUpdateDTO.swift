//
//  ProfileUpdateDTO.swift
//  FakeNFT
//
//  Created by Andy Kruch on 17.10.23.
//

import Foundation

struct ProfileUpdateRequest: NetworkRequest {
    let profileUpdateDTO: ProfileUpdateDTO

    var endpoint = URL(string: "\(Config.baseUrl)/profile/1")
    var httpMethod = HttpMethod.put
    
    var dto: Encodable? {
        profileUpdateDTO
    }
}

struct ProfileUpdateDTO: Encodable {
    let likes: [String]
    let id: String
}
