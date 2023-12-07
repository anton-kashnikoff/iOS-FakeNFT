import Foundation

final class StatisticsViewModel {
    private let model: StatisticsService
    
    var onChange: (() -> Void)?
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?
    
    private(set) var users: [User] = [] {
        didSet {
            onChange?()
        }
    }
    
    var sortType: StatSortType? {
        didSet {
            saveSortType()
            sortUsers()
            onChange?()
        }
    }
    
    init(model: StatisticsService) {
        self.model = model
        self.sortType = loadSortType()
    }
    
    func saveSortType() {
        if let sortType = sortType {
            UserDefaults.standard.set(sortType.rawValue, forKey: Config.usersSortTypeKey)
        } else {
            UserDefaults.standard.removeObject(forKey: Config.usersSortTypeKey)
        }
    }
    
    func loadSortType() -> StatSortType {
        if let rawValue = UserDefaults.standard.string(forKey: Config.usersSortTypeKey),
           let sortType = StatSortType(rawValue: rawValue) {
            return sortType
        } else {
            return .byRating
        }
    }
    
    func getUsers(showLoader: @escaping (_ active: Bool) -> Void) {
        showLoader(true)
        
        model.getUsers { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.sortUsers()
                case .failure(let error):
                    self.onError?(error) { [weak self] in
                        self?.getUsers(showLoader: showLoader)
                    }
                    self.users = []
                }
                showLoader(false)
            }
        }
    }
    
    
    func setSortedByName() {
        UserDefaults.standard.set(StatSortType.byName.rawValue, forKey: Config.usersSortTypeKey)
        sortType = .byName
    }
    
    func setSortedByRating() {
        UserDefaults.standard.set(StatSortType.byRating.rawValue, forKey: Config.usersSortTypeKey)
        sortType = .byRating
    }
    
    private func getSorted(users: [User], by sortType: StatSortType) -> [User] {
        switch sortType {
        case .byName:
            return users.sorted { $0.name < $1.name }
        case .byRating:
            return users.sorted { Int($0.rating) ?? 0 > Int($1.rating) ?? 0 }
        }
    }
    
    private func sortUsers() {
        if let sortType = sortType {
            users = getSorted(users: users, by: sortType)
        }
    }
}
