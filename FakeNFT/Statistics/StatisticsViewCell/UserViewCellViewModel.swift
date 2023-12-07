import Foundation

final class UserViewCellViewModel {
    private let user: User
    private let cellIndex: Int
    
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
    
    init(user: User, cellIndex: Int) {
        self.user = user
        self.cellIndex = cellIndex
    }
}
