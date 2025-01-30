import Kingfisher
import SafariServices
import UIKit

final class UserCardViewController: UIViewController {
    // MARK: - Private Properties

    private let userId: String

    private var viewModel: UserCardViewModel!
    
    private lazy var avatarView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var descripView: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textColor = .ypBlack
        label.font = .Regular.small
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameView: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = .Bold.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var webButton: UIButton = {
        let button = UIButton()
        button.setTitle("Перейти на сайт пользователя", for: .normal)
        button.setTitleColor(.ypBlack, for: .normal)
        button.titleLabel?.font = .Regular.medium
        button.layer.cornerRadius = 17
        button.clipsToBounds = true
        button.tintColor = .clear
        button.layer.borderColor = UIColor.ypBlack.cgColor
        button.layer.borderWidth = 1
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var nftLabel: UILabel = {
        let label = UILabel()
        label.text = "Коллекция NFT"
        label.textColor = .ypBlack
        label.font = .Bold.small
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    private lazy var nftButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(openWebView), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        
        let iconImageView = UIImageView(image: UIImage(named: "chevron.forward"))
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        stackView.addArrangedSubview(nftLabel)
        stackView.addArrangedSubview(iconImageView)
        
        button.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: button.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -8),
            stackView.topAnchor.constraint(equalTo: button.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
        ])

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getUsersCollection))
        stackView.addGestureRecognizer(tapGesture)
        stackView.isUserInteractionEnabled = true
        return button
    }()
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    // MARK: - init()
    
    init(userId: String) {
        self.userId = userId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    @objc
    private func openWebView() {
        guard let urlString = viewModel.user?.website,
              let url = URL(string: urlString)
        else { return }

        present(SFSafariViewController(url: url), animated: true)
    }
    
    @objc
    private func getUsersCollection() {
        let viewController = UsersCollectionViewController(
            viewModel: UsersCollectionViewModel(
                model: UsersCollectionService(),
                ids: viewModel.user?.nfts.compactMap { Int($0) }
            )
        )

        viewController.title = "Коллекция NFT"
        
        let backButton = UIBarButtonItem()
        backButton.title = String()
        backButton.tintColor = .ypBlack
        navigationItem.backBarButtonItem = backButton
        navigationItem.titleView?.backgroundColor = .ypBlack
        navigationController?.navigationBar.tintColor = .ypBlack
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func configure() {
        guard let user = viewModel.user,
              let validUrl = URL(string: user.avatar)
        else { return }

        let imageSize = CGSize(width: 70, height: 70)
        let placeholderSize = imageSize

        let options: KingfisherOptionsInfo = [
            .processor(RoundCornerImageProcessor(radius: Radius.heightFraction(0.5))),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        
        avatarView.kf
            .setImage(
                with: validUrl,
                placeholder: UIImage(named: "avatar")?.kf.resize(to: placeholderSize),
                options: options
            ) { result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async { [weak self] in
                        self?.avatarView.image = value.image
                        self?.avatarView.layer.cornerRadius = imageSize.width / 2
                        self?.avatarView.layer.masksToBounds = true
                    }
                case .failure(let error):
                    print("Error image download: \(error)")

                    let alert = UIAlertController(
                        title: "Ошибка при загрузке аватара",
                        message: error.localizedDescription,
                        preferredStyle: .alert
                    )
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "Попробовать снова",
                            style: .default
                        ) { [weak self] _ in
                            guard let self else { return }
                            self.viewModel.getUser(userId: self.userId)
                        }
                    )
                    
                    alert.addAction(
                        UIAlertAction(
                            title: "Отмена",
                            style: .cancel
                        )
                    )

                    self.present(alert, animated: true)
            }
        }

        nameView.text = user.name
        nameView.font = .Bold.medium
        descripView.text = user.description
        nftLabel.text = "Коллекция NFT (\(user.nfts.count))"
        nftLabel.tintColor = .ypBlack
        nftLabel.font = .Bold.small
    }
    
    // MARK: - Public Methods
    
    func setup() {
        UINavigationBar.appearance().tintColor = .ypBlack
        view.tintColor = .ypBlack
        
        viewModel = UserCardViewModel(model: UserCardService())
        viewModel.onChange = { [weak self] in
            self?.configure()
        }
        
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(
                title: "Ошибка при загрузке данных пользователя",
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
            
            alert.addAction(
                UIAlertAction(
                    title: "Отмена",
                    style: .cancel
                )
            )
            
            self?.present(alert, animated: true)
        }
        
        viewModel.getUser(userId: userId)
        setupConstraints()
        view.backgroundColor = .ypWhite
    }
    
    func setupConstraints() {
        view.backgroundColor = .ypWhite
        
        view.addSubview(avatarView)
        view.addSubview(nameView)
        view.addSubview(descripView)
        view.addSubview(webButton)
        view.addSubview(nftButton)
        
        avatarView.layer.cornerRadius = 35
        avatarView.layer.masksToBounds = true
        navigationItem.titleView?.backgroundColor = .ypBlack
        navigationController?.navigationBar.tintColor = .ypBlack
        
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalToConstant: 70),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor),
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 16),
            nameView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            descripView.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            descripView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descripView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            webButton.topAnchor.constraint(equalTo: descripView.bottomAnchor, constant: 30),
            webButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            webButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            webButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            webButton.heightAnchor.constraint(equalToConstant: 40),
            
            nftButton.topAnchor.constraint(equalTo: webButton.bottomAnchor, constant: 56),
            nftButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
