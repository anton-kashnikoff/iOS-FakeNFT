import UIKit

final class UsersCollectionViewController: UIViewController {
    private var viewModel: UsersCollectionViewModel!
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(NFTCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    init(viewModel: UsersCollectionViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func change() {
        collectionView.reloadData()
    }
    
    private func setup() {
        viewModel.onChange = { [weak self] in
            self?.change()
        }
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(
                title: "Ошибка при загрузке коллекции",
                message: error.localizedDescription,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                title: "Попробовать снова",
                style: .default,
                handler: { _ in
                    retryAction()
                }))
            self?.present(alert, animated: true, completion: nil)
        }
        
        viewModel.getUserNfts { [weak self] active in
            self?.showLoader(isShow: active)
        }
        
        view.backgroundColor = .ypWhite
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let safeArea = view.safeAreaLayoutGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .ypWhite
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        if viewModel.nftsIds == nil || viewModel.nftsIds?.isEmpty == true {
            let emptyLabel = UILabel()
            emptyLabel.text = "Коллекция пуста"
            emptyLabel.textColor = .ypBlack
            emptyLabel.textAlignment = .center
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            collectionView.addSubview(emptyLabel)
            
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
            ])
        }
    }
    
    func showLoader(isShow: Bool) {
        if isShow {
            UIBlockingProgressHUD.show()
        } else {
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension UsersCollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            viewModel.nfts.count
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath) as? NFTCell else {
            fatalError("Unable NFTCell")
        }
        
        let nft = viewModel.nfts[indexPath.row]
        cell.configure(with: nft)
        return cell
    }
}

extension UsersCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 16 - 16 - 16) / 3, height: 192)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        UIEdgeInsets(top: 20, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        0
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
}
