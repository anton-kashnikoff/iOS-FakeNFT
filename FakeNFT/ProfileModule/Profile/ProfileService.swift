//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Антон Кашников on 21/10/2023.
//

protocol ProfileServiceProtocol {
    func makeGetProfileRequest(id: String, _ handler: @escaping (Codable) -> Void)
    func makePutRequest(id: String, profile: Encodable, _ handler: @escaping (Codable) -> Void)
    func makeGetAllNFTsRequest(_ handler: @escaping (Codable) -> Void)
    func makeGetAllAuthorsRequest(_ handler: @escaping (Codable) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    // MARK: - Private properties
    
    private let networkClient = DefaultNetworkClient()
    
    // MARK: - Private methods
    
    func makeGetProfileRequest(id: String, _ handler: @escaping (Codable) -> Void) {
        let networkRequest = ProfileRequest(id: id)
        
        networkClient.send(request: networkRequest, type: Profile.self) { result in
            switch result {
            case .success(let success):
                handler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func makePutRequest(id: String, profile: Encodable, _ handler: @escaping (Codable) -> Void) {
        let networkRequest = ProfileRequest(id: id, httpMethod: .put, dto: profile)
        
        networkClient.send(request: networkRequest, type: Profile.self) { result in
            switch result {
            case .success(let success):
                handler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func makeGetAllNFTsRequest(_ handler: @escaping (Codable) -> Void) {
        let networkRequest = NFTsExampleRequest()
        
        networkClient.send(request: networkRequest, type: [ItemNFT].self) { result in
            switch result {
            case .success(let success):
                handler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    func makeGetAllAuthorsRequest(_ handler: @escaping (Codable) -> Void) {
        let networkRequest = UsersExampleRequest()
        
        networkClient.send(request: networkRequest, type: [User].self) { result in
            switch result {
            case .success(let success):
                handler(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
