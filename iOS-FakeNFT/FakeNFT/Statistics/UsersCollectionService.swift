import Foundation

final class UsersCollectionService {
    // MARK: - Private Properties
    
    private let defaultNetworkClient = DefaultNetworkClient()
    
    // MARK: - Public Methods
    
    func fetchNfts(ids: [Int], completion: @escaping (Result<[ItemNFT], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        var resultNfts = [ItemNFT]()
        
        for id in ids {
            dispatchGroup.enter()
            
            defaultNetworkClient
                .send(
                    request: Request(
                        endpoint: URL(
                            string: Config.baseUrl + "/nft" + "/\(id)"
                        ),
                        httpMethod: .get
                    ),
                    type: ItemNFT.self
                ) { result in
                    switch result {
                    case .success(let nft):
                        resultNfts.append(nft)
                    case .failure(let error):
                        print("Error: \(error)")
                    }

                    dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(.success(resultNfts))
        }
    }
}
