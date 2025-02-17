//
//  CatalogViewModel.swift
//  FakeNFT
//
//  Created by Andy Kruch on 10.10.23.
//

import Foundation

final class CatalogViewModel: NSObject {
    // MARK: - Private Properties
    
    private let sorter = SortNFTsCollections()
    
    private(set) var collections = [Collection]()
    
    // MARK: - Public Properties
    
    var reloadData: (() -> Void)?
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?
    
    // MARK: - Private Methods
    
    private func fetchData() {
        UIBlockingProgressHUD.show()

        DefaultNetworkClient().send(
            request: CollectionRequests.collection,
            type: [Collection].self
        ) { [weak self] result in
            switch result {
            case .success(let data):
                self?.collections = data
                DispatchQueue.main.async {
                    self?.reloadData?()
                    UIBlockingProgressHUD.dismiss()
                }
            case.failure(let error):
                DispatchQueue.main.async {
                    self?.onError?(error) { [weak self] in
                        self?.fetchData()
                    }
                    UIBlockingProgressHUD.dismiss()
                }
            }
        }
    }
    
    // MARK: - Public Methods
    
    func updateData() {
        fetchData()
    }
    
    func sortByName() {
        collections = collections.sorted {
            $0.name < $1.name
        }
        
        sorter.setSortValue(value: SortNFTsCollectionType.byName.rawValue)
        reloadData?()
    }
    
    func sortByNFTsCount() {
        collections = collections.sorted {
            $0.nfts.count > $1.nfts.count
        }
        
        sorter.setSortValue(value: SortNFTsCollectionType.byNFTsCount.rawValue)
        reloadData?()
    }
}
