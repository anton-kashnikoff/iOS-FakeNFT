import ProgressHUD
import UIKit

final class StatisticsViewController: UIViewController {
    // MARK: - Private Properties

    private var viewModel: StatisticsViewModel!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UserViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset = UIEdgeInsets(top: .zero, left: 32, bottom: .zero, right: 32)
        table.separatorStyle = .none
        table.bounces = false
        table.delegate = self
        table.dataSource = self
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .ypLightGrey
        return table
    }()
    
    private lazy var menuButton: UIBarButtonItem = {
        let menuButton = UIBarButtonItem(
            image: UIImage(named: "Sort"),
            style: .plain,
            target: self,
            action: #selector(showMenu)
        )

        menuButton.tintColor = .ypBlack
        return menuButton
    }()

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Private Methods
    
    @objc
    private func showMenu() {
        showAlert()
    }

    // MARK: - Public Methods
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: nil,
            message: "Сортировка",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(
            UIAlertAction(
                title: "По имени",
                style: .default
            ) { [weak self] _ in
                self?.viewModel.setSortedByName()
            }
        )
        
        alert.addAction(
            UIAlertAction(
                title: "По рейтингу",
                style: .default
            ) { [weak self] _ in
                self?.viewModel.setSortedByRating()
            }
        )

        alert.addAction(
            UIAlertAction(
                title: "Закрыть",
                style: .cancel
            )
        )
        
        present(alert, animated: true)
    }
    
    func showProgress(isShow: Bool) {
        if isShow {
            view.isUserInteractionEnabled = false
            ProgressHUD.show()
        } else {
            view.isUserInteractionEnabled = true
            ProgressHUD.dismiss()
        }
    }
    
    func setup() {
        view.backgroundColor = .ypWhite
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let navigationController = UINavigationController(rootViewController: StatisticsViewController())
        navigationController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let backButton = UIBarButtonItem()
        backButton.title = String()
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = menuButton

        viewModel = StatisticsViewModel(model: StatisticsService())
        viewModel.onChange = { [weak self] in
            self?.updateTable()
        }
        
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(
                title: "Ошибка при загрузке",
                message: error.localizedDescription,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: "Попробовать снова",
                    style: .default
                ) { _ in
                    retryAction()
                }
            )

            self?.present(alert, animated: true)
        }
        
        viewModel.getUsers(showLoader: showProgress)
    }
}

// MARK: - UITableViewDelegate

extension StatisticsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let user = viewModel.users[indexPath.row]
        let viewController = UserCardViewController(userId: user.id)
        viewController.modalPresentationStyle = .fullScreen
        viewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension StatisticsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.users.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let userCell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        ) as? UserViewCell else {
            assertionFailure("Can't get cell for statisticsVC")
            return UITableViewCell()
        }
        
        let user = viewModel.users[indexPath.row]
        userCell.configure(with: UserViewCellViewModel(user: user, cellIndex: indexPath.row))
        userCell.backgroundColor = .ypWhite
        return userCell
    }
}
