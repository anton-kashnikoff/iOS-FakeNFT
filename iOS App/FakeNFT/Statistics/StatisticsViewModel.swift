import Foundation

final class StatisticsViewModel {
    // MARK: - Private Properties

    private let model: StatisticsService

    // MARK: - Public Properties

    private(set) var users = [User]() {
        didSet {
            onChange?()
        }
    }

    var onChange: (() -> Void)?
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?

    var sortType: StatSortType? {
        didSet {
            saveSortType()
            sortUsers()
            onChange?()
        }
    }

    // MARK: - init()
    
    init(model: StatisticsService) {
        self.model = model
        sortType = loadSortType()
    }

    // MARK: - Private Methods

    private func getSorted(users: [User], by sortType: StatSortType) -> [User] {
        switch sortType {
        case .byName:
            users.sorted { $0.name < $1.name }
        case .byRating:
            users.sorted { Int($0.rating) ?? .zero > Int($1.rating) ?? .zero }
        }
    }
    
    private func sortUsers() {
        if let sortType = sortType {
            users = getSorted(users: users, by: sortType)
        }
    }
    
    // MARK: - Public Methods
    
    func saveSortType() {
        if let sortType {
            UserDefaults.standard.set(sortType.rawValue, forKey: Config.usersSortTypeKey)
        } else {
            UserDefaults.standard.removeObject(forKey: Config.usersSortTypeKey)
        }
    }
    
    func loadSortType() -> StatSortType {
        if let rawValue = UserDefaults.standard.string(forKey: Config.usersSortTypeKey),
           let sortType = StatSortType(rawValue: rawValue) {
            sortType
        } else {
            .byRating
        }
    }
    
    func getUsers(showLoader: @escaping (_ active: Bool) -> Void) {
        showLoader(true)
        
        model.getUsers { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self.users = users
                    self.sortUsers()
                case .failure(let error):
                    self.onError?(error) {
                        self.getUsers(showLoader: showLoader)
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
}
