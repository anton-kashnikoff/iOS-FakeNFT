import Foundation

final class StatisticsService {
    // MARK: - Private Properties

    private let networkClient = DefaultNetworkClient()

    // MARK: - Public Methods

    func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        networkClient
            .send(
                request: Request(
                    endpoint: URL(
                        string: Config.baseUrl + "/users"
                    ),
                    httpMethod: .get
                ),
                type: [User].self,
                onResponse: completion
            )
    }
}
