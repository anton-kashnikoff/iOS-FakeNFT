import Dispatch

final class UsersCollectionViewModel {
    // MARK: - Private Properties

    private let model: UsersCollectionService
    
    // MARK: - Public Properties
    
    private(set) var nftsIds: [Int]?
    private(set) var nfts = [ItemNFT]() {
        didSet {
            onChange?()
        }
    }
    
    var onChange: (() -> Void)?
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?
    
    // MARK: - init()
    
    init(model: UsersCollectionService, ids: [Int]? ) {
        self.model = model
        nftsIds = ids
    }
    
    // MARK: - Public Properties
    
    func getUserNfts(showLoader: @escaping (_ active: Bool) -> Void ) {
        guard let ids = nftsIds, !ids.isEmpty else { return }
        
        showLoader(true)
        model.fetchNfts(ids: ids) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let nfts):
                    self.nfts = nfts
                case .failure(let error):
                    self.onError?(error) {
                        self.getUserNfts(showLoader: showLoader)
                    }
                }
                
                showLoader(false)
            }
        }
    }
}
