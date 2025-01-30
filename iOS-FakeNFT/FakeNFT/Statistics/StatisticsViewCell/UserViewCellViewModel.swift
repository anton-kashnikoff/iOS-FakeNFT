import Foundation

final class UserViewCellViewModel {
    // MARK: - Private Properties

    private let user: User
    private let cellIndex: Int

    // MARK: - Public Properties

    var index: String {
        String(cellIndex + 1)
    }
    
    var name: String {
        user.name
    }
    
    var count: String {
        String(user.nfts.count)
    }
    
    var avatarURL: URL? {
        URL(string: user.avatar)
    }

    // MARK: - init()

    init(user: User, cellIndex: Int) {
        self.user = user
        self.cellIndex = cellIndex
    }
}
