//
//  CollectionViewModel.swift
//  FakeNFT
//
//  Created by Andy Kruch on 11.10.23.
//

import Foundation

final class CollectionViewModel: NSObject {
    let collection: Collection
    
    var user: UserCollection?
    var nft: [ItemNFT]?
    var profile: Profile?
    var order: OrderCollection?
    
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?
    
    var reloadData: (() -> Void)?
    
    init(collection: Collection) {
        self.collection = collection
        super .init()
        fetchUserData(by: collection.author)
        fetchNFTData()
        fetchProfileData()
        fetchOrderData()
    }
    
    func fetchUserData(by id: String) {
        UIBlockingProgressHUD.show()
        DefaultNetworkClient().send(request: CollectionRequests.userId(userId: id), type: User.self) { [weak self] result in
            switch result {
            case .success(let data):
                self?.user = UserCollection(with: data)
                DispatchQueue.main.async {
                    self?.reloadData?()
                    UIBlockingProgressHUD.dismiss()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error) { [weak self] in
                        self?.fetchUserData(by: id)
                        UIBlockingProgressHUD.dismiss()
                    }
                }
            }
        }
    }
    
    func fetchNFTData() {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: CollectionRequests.nft, type: [ItemNFT].self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.nft = data.map { $0 }
                    DispatchQueue.main.async { [weak self] in
                        self?.reloadData?()
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error) { [weak self] in
                            self?.fetchNFTData()
                            UIBlockingProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func fetchOrderData() {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: CollectionRequests.order, type: Order.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.order = OrderCollection(with: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.reloadData?()
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error) { [weak self] in
                            self?.fetchOrderData()
                            UIBlockingProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    private func fetchProfileData() {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: CollectionRequests.profile, type: Profile.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.profile = data
                    DispatchQueue.main.async { [weak self] in 
                        self?.reloadData?()
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error) { [weak self] in
                            self?.fetchProfileData()
                            UIBlockingProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func updateLikeForNFT(with id: String) {
        var likes = profile?.likes
        if let index = likes?.firstIndex(of: id) {
            likes?.remove(at: index)
        } else {
            likes?.append(id)
        }
        guard let likes = likes,
              let id = profile?.id
        else { return }
        let dto = ProfileUpdateDTO(likes: likes, id: id)
        updateProfileData(with: dto)
    }
    
    private func updateProfileData(with dto: ProfileUpdateDTO) {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: ProfileUpdateRequest(profileUpdateDTO: dto), type: Profile.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.profile = data
                    DispatchQueue.main.async {
                        self?.reloadData?()
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error) { [weak self] in
                            self?.updateProfileData(with: dto)
                            UIBlockingProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func updateCartForNFT(with id: String) {
        var nfts = order?.nfts
        if let index = nfts?.firstIndex(of: id) {
            nfts?.remove(at: index)
        } else {
            nfts?.append(id)
        }
        guard let nfts = nfts,
              let id = order?.id
        else { return }
        let dto = OrderUpdateDTO(nfts: nfts, id: id)
        updateOrderData(with: dto)
    }
    
    private func updateOrderData(with dto: OrderUpdateDTO) {
        UIBlockingProgressHUD.show()
        DispatchQueue.global(qos: .background).async {
            DefaultNetworkClient().send(request: OrderUpdateRequest(orderUpdateDTO: dto), type: Order.self) { [weak self] result in
                switch result {
                case .success(let data):
                    self?.order = OrderCollection(with: data)
                    DispatchQueue.main.async { [weak self] in
                        self?.reloadData?()
                        UIBlockingProgressHUD.dismiss()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.onError?(error) { [weak self] in
                            self?.updateOrderData(with: dto)
                            UIBlockingProgressHUD.dismiss()
                        }
                    }
                }
            }
        }
    }
    
    func nfts(by id: String) -> ItemNFT? {
        nft?.first { $0.id == id }
    }
    
    func isNFTLiked(with nftId: String) -> Bool {
        return profile?.likes.contains(nftId) ?? false
    }
    
    func isNFTInOrder(with nftId: String) -> Bool {
        return order?.nfts.contains(nftId) ?? false
    }
}
