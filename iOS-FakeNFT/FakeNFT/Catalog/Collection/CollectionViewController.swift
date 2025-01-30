//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Andy Kruch on 11.10.23.
//

import UIKit
import Kingfisher

final class CollectionViewController: UIViewController {
    // MARK: - Private Properties
    
    private let viewModel: CollectionViewModel
 
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        
        [
            ImageCollectionViewCell.self,
            DescriptionCollectionViewCell.self,
            NFTCollectionViewCell.self
        ].forEach { type in
            collectionView.register(
                type,
                forCellWithReuseIdentifier: type.identifier
            )
        }
        
        return collectionView
    }()
    
    // MARK: - init()
    
    init(viewModel: CollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.reloadData = collectionView.reloadData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        addSubviews()
        setupConstraints()
        setupNavBar()
        setupCollectionView()
        
        viewModel.onError = { [weak self] error, retryAction in
            let alertController = UIAlertController(
                title: "Не удалось получить данные",
                message: nil,
                preferredStyle: .alert
            )
            
            alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alertController.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
                retryAction()
            })
            
            self?.present(alertController, animated: true)
        }
    }
    
    // MARK: - Private Methods
        
    private func addSubviews() {
        [collectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func likeButtonTapped(nftIndex: String) {
        viewModel.updateLikeForNFT(with: nftIndex)
    }
    
    private func cartButtonTapped(nftIndex: String) {
        viewModel.updateCartForNFT(with: nftIndex)
    }
    
    private func setupNavBar() {
        if let navigationBar = navigationController?.navigationBar {
            let leftImageButton = UIImage(systemName: "chevron.backward")?
                .withTintColor(.black)
                .withRenderingMode(.alwaysOriginal)

            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: leftImageButton,
                style: .plain,
                target: self,
                action: #selector(leftNavigationBarButtonTapped)
            )

            navigationBar.tintColor = .black
            navigationBar.isTranslucent = true
        }
    }
    
    private func showWebViewAboutAuthor() {
        let webView = WebView()
        guard let url = URL(string: viewModel.user?.website ?? String()) else { return }
        webView.url = url
        
        navigationController?.pushViewController(webView, animated: true)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    private func showCollectionItemView() {
        navigationController?.pushViewController(CollectionItemViewController(), animated: true)
    }
    
    @objc
    private func leftNavigationBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        guard let section = CollectionNFTSection(rawValue: section) else { return .zero }
        
        return switch section {
        case .image, .description: 1
        case .nft: viewModel.collection.nfts.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let section = CollectionNFTSection(
            rawValue: indexPath.section
        ) else {
            return UICollectionViewCell()
        }
        
        switch section {
        case .image:
            guard let imageCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ImageCollectionViewCell.identifier,
                for: indexPath
            ) as? ImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            if let imageURLString = viewModel.collection.cover,
               let imageURl = URL(string: imageURLString.encodeURL) {
                imageCell.imageView.kf.setImage(with: imageURl)
            }
            
            imageCell.configure(collectionImageAction: showCollectionItemView)
            return imageCell
        case .description:
            guard let descriptionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DescriptionCollectionViewCell.identifier,
                for: indexPath
            ) as? DescriptionCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            descriptionCell.configure(
                collectionName: viewModel.collection.name,
                subTitle: "Автор коллекции:",
                authorName: viewModel.user?.name ?? String(),
                description: viewModel.collection.description,
                authorNameButtonAction: showWebViewAboutAuthor
            )
            
            return descriptionCell
        case .nft:
            guard let nftCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: NFTCollectionViewCell.identifier,
                for: indexPath
            ) as? NFTCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let nftIndex = viewModel.collection.nfts[indexPath.row]
            
            if let imageURLString = viewModel.nfts(by: nftIndex)?.images.first,
               let imageURL = URL(string: imageURLString.encodeURL),
               let price = viewModel.nfts(by: nftIndex)?.price.ethCurrency,
               let rating = viewModel.nfts(by: nftIndex)?.rating {
                let isNFTLiked = viewModel.isNFTLiked(with: nftIndex)
                let isNFTInOrder = viewModel.isNFTInOrder(with: nftIndex)
                
                nftCell
                    .configure(
                        nftImage: imageURL,
                        likeOrDislike: isNFTLiked ? "like" : "dislike",
                        rating: rating,
                        nftName: viewModel.nfts(by: nftIndex)?.name ?? String(),
                        price: price,
                        cartImage: isNFTInOrder ? "inCart" : "cart"
                    ) { [weak self] in
                        self?.likeButtonTapped(nftIndex: nftIndex)
                    } cartButtonInteraction: { [weak self] in
                        self?.cartButtonTapped(nftIndex: nftIndex)
                    }
            }
            
            return nftCell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        CollectionNFTSection.allCases.count
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        guard let section = CollectionNFTSection(
            rawValue: indexPath.section
        ) else {
            return .zero
        }
        
        switch section {
        case .image:
            return CGSize(width: self.collectionView.bounds.width, height: 310)
        case .description:
            return CGSize(width: self.collectionView.bounds.width, height: 160)
        case .nft:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first
            else { return .zero }

            let width = (window.bounds.width - 50) / 3
            return CGSize(width: width, height: 200)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        .zero
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        guard let section = CollectionNFTSection(rawValue: section) else { return .zero }
        
        return switch section {
        case .image, .description: .zero
        case .nft: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
}
