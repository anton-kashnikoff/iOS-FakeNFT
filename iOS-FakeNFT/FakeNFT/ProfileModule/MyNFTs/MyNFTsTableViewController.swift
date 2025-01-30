//
//  MyNFTsTableViewController.swift
//  FakeNFT
//
//  Created by Антон Кашников on 19/10/2023.
//

import UIKit

final class MyNFTsTableViewController: UIViewController {
    // MARK: - Private properties
    
    private let profileViewModel: ProfileViewModel
    
    private var profileObserver: NSObjectProtocol?
    
    // MARK: - UI-elements
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activitiIndicator = UIActivityIndicatorView(style: .medium)
        activitiIndicator.color = .ypBlack
        return activitiIndicator
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .ypWhite
        tableView.rowHeight = 140
        tableView.separatorStyle = .none
        tableView.register(MyNFTsTableViewCell.self, forCellReuseIdentifier: MyNFTsTableViewCell.reuseIdentifier)
        return tableView
    }()
    
    private let label: UILabel = {
        let label = UILabel(text: "У Вас ещё нет NFT")
        label.textColor = .ypBlack
        label.font = .Bold.small
        label.isHidden = true
        return label
    }()
    
    // MARK: - Public properties
    
    var navTitle: String?
    
    // MARK: - init()
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .ypWhite
        tabBarController?.tabBar.isHidden = true
        
        setupView()
        setupNavigationBar()
        setupTableView()
        setupLabel()
        setupActivityIndicator()

        reloadData()
    }
    
    // MARK: - Private methods
    
    private func setupNavigationBar() {
        title = navTitle
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .backward),
            style: .plain,
            target: self,
            action: #selector(backButtonDidTap)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(resource: .sort),
            style: .plain,
            target: self,
            action: #selector(sortButtonDidTap)
        )
    }
    
    private func setupView() {
        [activityIndicator, tableView, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        view.addSubview(tableView)
        
        let topOffset: CGFloat = 20
        tableView.contentInset = UIEdgeInsets(top: topOffset, left: .zero, bottom: .zero, right: .zero)
        tableView.setContentOffset(CGPoint(x: .zero, y: -topOffset), animated: false)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupLabel() {
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func reloadData() {
        let filterStatus = UserDefaults.standard.integer(forKey: "indexOfFilter")
        
        switch filterStatus {
        case 0: profileViewModel.myNFTs?.sort { $0.price > $1.price }
        case 1: profileViewModel.myNFTs?.sort { $0.rating > $1.rating }
        case 2: profileViewModel.myNFTs?.sort { $0.name < $1.name }
        default: break
        }
        
        tableView.reloadData()
        activityIndicator.stopAnimating()
        reloadPlaceholderView()
    }
    
    private func reloadPlaceholderView() {
        if let nfts = profileViewModel.myNFTs {
            if nfts.isEmpty {
                title = String()
                tableView.isHidden = true
                
                view.backgroundColor = .ypWhite
                label.isHidden = false
            }
        }
    }
    
    private func setFilterType(_ type: Int) {
        UserDefaults.standard.set(type, forKey: "indexOfFilter")
        reloadData()
    }
    
    @objc
    private func backButtonDidTap() {
        profileViewModel.updateProfileInfo()
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func sortButtonDidTap() {
        let alertController = UIAlertController(title: "Сортировка", message: nil, preferredStyle: .actionSheet)
        
        alertController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = .alertColor
        
        alertController.addAction(
            UIAlertAction(title: "По цене", style: .default) { [weak self] _ in
                self?.setFilterType(0)
            }
        )
        
        alertController.addAction(
            UIAlertAction(title: "По рейтингу", style: .default) { [weak self] _ in
                self?.setFilterType(1)
            }
        )
        
        alertController.addAction(
            UIAlertAction(title: "По названию", style: .default) { [weak self] _ in
                self?.setFilterType(2)
            }
        )
        
        alertController.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension MyNFTsTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        profileViewModel.myNFTs?.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MyNFTsTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? MyNFTsTableViewCell else { return UITableViewCell() }
        
        cell.backgroundColor = .ypWhite
        
        guard let nft = profileViewModel.myNFTs?[indexPath.row],
              let authorName = profileViewModel.authors?[indexPath.row].name
        else {
            return UITableViewCell()
        }
        
        cell.buttonTappedHandler = { [weak self, weak cell, weak profileViewModel] in
            guard let profileViewModel else { return }
            
            let isLiked = profileViewModel.isLiked(nft)
            
            self?.profileViewModel.updateLike(for: nft, isLiked)
            cell?.updateLike(isLiked)
            
            self?.reloadData()
        }
        
        cell.updateNameLabel(nft.name)
        cell.updateRating(nft.rating)
        cell.updatePrice(nft.price)
        cell.updateAuthor(authorName)
        cell.updateLike(profileViewModel.isLiked(nft))
        profileViewModel.getPhoto(imageView: cell.nftImageView, index: indexPath.row, list: .my)
        
        return cell
    }
}
