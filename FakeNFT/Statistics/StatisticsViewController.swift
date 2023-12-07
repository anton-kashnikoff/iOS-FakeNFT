import ProgressHUD
import UIKit

final class StatisticsViewController: UIViewController {
    private var viewModel: StatisticsViewModel!
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(UserViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorInset = .init(top: 0, left: 32, bottom: 0, right: 32)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @objc
    private func showMenu() {
        showAlert()
    }
    
    func updateTable() {
        tableView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(
            title: nil, message: "Сортировка",
            preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(
            title: "По имени",
            style: .default,
            handler: { (_)in
                self.viewModel.setSortedByName()
            }))
        
        alert.addAction(UIAlertAction(
            title: "По рейтингу",
            style: .default,
            handler: { (_)in
                self.viewModel.setSortedByRating()
            }))
        
        alert.addAction(UIAlertAction(
            title: "Закрыть",
            style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showProgress(isShow: Bool) {
        if isShow {
            self.view.isUserInteractionEnabled = false
            ProgressHUD.show()
        } else {
            self.view.isUserInteractionEnabled = true
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
        backButton.title = ""
        navigationItem.backBarButtonItem = backButton
        navigationItem.rightBarButtonItem = menuButton
        let model = StatisticsService()
        
        viewModel = StatisticsViewModel(model: model)
        
        viewModel.onChange = { [weak self] in
            self?.updateTable()
        }
        
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(title: "Ошибка при загрузке", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Попробовать снова", style: .default, handler: { _ in
                retryAction()
            }))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.getUsers(showLoader: showProgress)
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath) {
            let user = viewModel.users[indexPath.row]
            
            let viewController = UserCardViewController(userId: user.id)
            viewController.modalPresentationStyle = .fullScreen
            viewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(viewController, animated: true)
        }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int) -> Int {
            viewModel.users.count
        }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            guard let userCell = cell as? UserViewCell else {
                assertionFailure("Can't get cell for statisticsVC")
                return UITableViewCell()
            }
            
            let user = viewModel.users[indexPath.row]
            let cellViewModel = UserViewCellViewModel(user: user, cellIndex: indexPath.row)
            userCell.configure(with: cellViewModel)
            userCell.backgroundColor = .ypWhite
            return userCell
        }
}
