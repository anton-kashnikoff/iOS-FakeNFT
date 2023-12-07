//
//  FavoritesNFTsCollectionViewController.swift
//  FakeNFT
//
//  Created by Антон Кашников on 20/10/2023.
//

import UIKit

final class FavoritesNFTsCollectionViewController: UIViewController {
    // MARK: - UI-elements
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: .medium)
        activitiIndicator.color = .ypBlack
        activitiIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activitiIndicator
    }()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .ypWhite
        collectionView.register(
            FavoritesNFTsCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoritesNFTsCollectionViewCell.reuseIdentifier
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let label: UILabel = {
        let label = UILabel(text: "У Вас ещё нет избранных NFT")
        label.textColor = .ypBlack
        label.font = UIFont.Bold.small
        label.isHidden = true
        return label
    }()
    
    // MARK: - Private Properties
    
    private let profileViewModel: ProfileViewModel
    
    private var profileObserver: NSObjectProtocol?
    
    // MARK: - Public properties
    
    var navTitle: String?
    
    // MARK: - UIViewController
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        
        tabBarController?.tabBar.isHidden = true
        title = navTitle
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "Backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        
        setupCollectionView()
        setupLabel()
        setupActivityIndicator()
        
        reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func reloadData() {
        collectionView.reloadData()
        activityIndicator.stopAnimating()
        reloadPlaceholderView()
    }
    
    private func reloadPlaceholderView() {
        if let nfts = profileViewModel.favoritesNFTs {
            if nfts.isEmpty {
                title = ""
                collectionView.isHidden = true
                
                view.backgroundColor = .ypWhite
                label.isHidden = false
            }
        }
    }
    
    @objc
    private func backButtonDidTap() {
        profileViewModel.updateProfileInfo()
        navigationController?.popViewController(animated: true)
    }
}

// MARK: UICollectionViewDataSource

extension FavoritesNFTsCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileViewModel.favoritesNFTs?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FavoritesNFTsCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as? FavoritesNFTsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.backgroundColor = .ypWhite
        
        guard let nft = profileViewModel.favoritesNFTs?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.buttonTappedHandler = { [weak self] in
            self?.profileViewModel.removeLike(nft: nft)
            self?.reloadData()
        }
        
        cell.updateNameLabel(nft.name)
        cell.updateRating(nft.rating)
        cell.updatePrice(nft.price)
        profileViewModel.getPhoto(imageView: cell.nftImageView, index: indexPath.row, list: .favorites)
    
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout

extension FavoritesNFTsCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: (collectionView.bounds.width - 39) / 2, height: 80)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        7
    }
}
