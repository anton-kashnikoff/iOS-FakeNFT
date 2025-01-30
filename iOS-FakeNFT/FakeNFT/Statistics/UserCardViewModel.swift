import Dispatch

final class UserCardViewModel {
    // MARK: - Private Properties

    private let model: UserCardService
    
    // MARK: - Public Properties
    
    private(set) var user: User? {
        didSet {
            onChange?()
        }
    }
    
    var onChange: (() -> Void)?
    var onError: ((_ error: Error, _ retryAction: @escaping () -> Void) -> Void)?
    
    // MARK: - init()
    
    init(model: UserCardService) {
        self.model = model
    }
    
    // MARK: - Public Methods
    
    func getUser(userId: String) {
        model.getUser(userId: userId) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    self.onError?(error) {
                        self.getUser(userId: userId)
                    }

                    self.user = nil
                }
            }
        }
    }
}
