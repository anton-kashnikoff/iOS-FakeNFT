import Foundation

final class UserCardService {
    // MARK: - Private Properties

    private let defaultNetworkClient = DefaultNetworkClient()
    
    // MARK: - Public Methods

    func getUser(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        defaultNetworkClient
            .send(
                request: Request(
                    endpoint: URL(
                        string: Config.baseUrl + "/users" + "/\(userId)"
                    ),
                    httpMethod: .get
                ),
                type: User.self,
                onResponse: completion
            )
    }
}
