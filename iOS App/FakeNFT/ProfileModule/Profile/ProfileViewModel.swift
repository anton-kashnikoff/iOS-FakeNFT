//
//  ProfileViewModel.swift
//  FakeNFT
//
//  Created by Антон Кашников on 21/10/2023.
//

import Kingfisher
import UIKit

final class ProfileViewModel {
    // MARK: - Static properties
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileInfoDidChange")
    static let nftsChangedNotification = Notification.Name(rawValue: "NFTsInfoDidChange")
    
    // MARK: - Public properties

    let profileService: ProfileServiceProtocol? = ProfileService()
    let viewController: ProfileViewControllerProtocol?
    
    var profile: Profile?
    var myNFTs: [ItemNFT]? = []
    var authors: [User]? = []
    var favoritesNFTs: [ItemNFT]? = []
    var nfts: [ItemNFT]? = []
    
    // MARK: - init()
    
    init(viewController: ProfileViewControllerProtocol) {
        self.viewController = viewController
    }
    
    // MARK: - Private methods
    
    private func addLike(nft: ItemNFT) {
        guard var favoritesNFTs, let profile else {
            return
        }
        
        favoritesNFTs.append(nft)
        favoritesNFTs.sort { $0.id < $1.id }
        
        self.favoritesNFTs = favoritesNFTs
        
        self.profile = .init(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: favoritesNFTs.map { $0.id },
            id: profile.id
        )
    }
    
    private func sortProfileNFTs(_ profile: Profile) -> Profile {
        var likes = sortArray(profile.likes)
        
        for (index, item) in likes.enumerated() {
            if item == "0" {
                likes.remove(at: index)
            }
        }
        
        return .init(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: sortArray(profile.nfts),
            likes: likes,
            id: profile.id
        )
    }
    
    private func sortArray(_ array: [String]) -> [String] {
        array
            .compactMap { Int($0) }
            .sorted()
            .map { String($0) }
    }
    
    // MARK: - Public methods
    
    func getProfile(id: String) {
        profileService?.makeGetProfileRequest(id: id) { [weak self] profile in
            if let profile = profile as? Profile {
                self?.profile = self?.sortProfileNFTs(profile)
                NotificationCenter.default.post(name: ProfileViewModel.didChangeNotification, object: self)
            }
        }
    }
    
    func updatePhoto(_ imageView: UIImageView) {
        guard let profileImagePath = profile?.avatar else {
            return
        }
        
        let processor = RoundCornerImageProcessor(cornerRadius: 35, backgroundColor: .ypBlack)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: profileImagePath), options: [.processor(processor)])
    }
    
    func updateProfileInfo() {
        guard let profile else { return }
        
        profileService?.makePutRequest(
            id: profile.id,
            profile: profile
        ) { [weak self] profile in
            if let profile = profile as? Profile {
                self?.profile = profile
                NotificationCenter.default.post(name: ProfileViewModel.didChangeNotification, object: self)
            }
        }
    }
    
    func changeProfileInfo(for field: ProfileInfo, _ string: String) {
        guard let profile else { return }
        
        self.profile = switch field {
        case .name:
            Profile(name: string, avatar: profile.avatar, description: profile.description, website: profile.website, nfts: profile.nfts, likes: profile.likes, id: profile.id)
        case .description:
            Profile(name: profile.name, avatar: profile.avatar, description: string, website: profile.website, nfts: profile.nfts, likes: profile.likes, id: profile.id)
        case .website:
            Profile(name: profile.name, avatar: profile.avatar, description: profile.description, website: string, nfts: profile.nfts, likes: profile.likes, id: profile.id)
        }
    }
    
    func getPhoto(imageView: UIImageView, index: Int, list: NFTListType) {
        let nft = switch list {
        case .my: myNFTs?[index]
        case .favorites: favoritesNFTs?[index]
        }
        
        guard let nft else { return }
        
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: URL(string: nft.images.first!),
            options: [.processor(RoundCornerImageProcessor(cornerRadius: 12, backgroundColor: .ypBlack))]
        )
    }
    
    func getAllNFTs() {
        profileService?.makeGetAllNFTsRequest { [weak self] nfts in
            if let nfts = nfts as? [ItemNFT] {
                self?.nfts = nfts
                self?.getAllAuthors()
            }
        }
    }
    
    func getAllAuthors() {
        profileService?.makeGetAllAuthorsRequest { [weak self] authors in
            if let authors = authors as? [User] {
                self?.authors = authors
                NotificationCenter.default.post(
                    name: ProfileViewModel.nftsChangedNotification,
                    object: self
                )
            }
        }
    }
    
    func sortNFTs() {
        guard let profile else { return }
        
        nfts?.forEach { nft in
            if profile.nfts.contains(nft.id) {
                myNFTs?.append(nft)
            }
            
            if profile.likes.contains(nft.id) {
                favoritesNFTs?.append(nft)
            }
        }
        
        self.profile = sortProfileNFTs(profile)
    }
    
    func isLiked(_ nft: ItemNFT) -> Bool {
        guard let favoritesNFTs else { return false }
        
        return favoritesNFTs.contains(nft)
    }
    
    func removeLike(nft: ItemNFT) {
        guard var favoritesNFTs,
              let index = favoritesNFTs.firstIndex(of: nft),
              let profile
        else { return }
        
        favoritesNFTs.remove(at: index)
        self.favoritesNFTs = favoritesNFTs
        
        self.profile = .init(
            name: profile.name,
            avatar: profile.avatar,
            description: profile.description,
            website: profile.website,
            nfts: profile.nfts,
            likes: favoritesNFTs.map { $0.id },
            id: profile.id
        )
    }
    
    func updateLike(for nft: ItemNFT, _ isLiked: Bool) {
        if isLiked {
            removeLike(nft: nft)
        } else {
            addLike(nft: nft)
        }
    }
}
