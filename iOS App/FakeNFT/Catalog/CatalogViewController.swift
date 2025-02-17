//
//  CatalogViewController.swift
//  FakeNFT
//
//  Created by Andy Kruch on 10.10.23.
//

import Kingfisher
import UIKit

final class CatalogViewController: UIViewController {
    // MARK: - Private Properties
    
    private var viewModel = CatalogViewModel()
    private var collections: [Collection] {
        viewModel.collections
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CatalogTableViewCell.self, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 8, right: 0)
        tableView.backgroundColor = .white
        tableView.separatorColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var loadIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - init()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        viewModel.reloadData = self.tableView.reloadData
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addSubviews()
        setupConstraints()
        setupNavBar()
        
        viewModel.updateData()
        
        viewModel.onError = { [weak self] error, retryAction in
            let alert = UIAlertController(
                title: "Не удалось получить данные",
                message: nil,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            alert.addAction(UIAlertAction(title: "Повторить", style: .default) { _ in
                retryAction()
            })
            
            self?.present(alert, animated: true)
        }
    }
    
    // MARK: - Private Methods
    
    private func addSubviews() {
        [tableView, loadIndicator].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func setupNavBar() {
        let sortButtonImage = UIImage(named: "sortButton")
        let sortButton = UIBarButtonItem(
            image: sortButtonImage,
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        
        sortButton.target = self
        sortButton.action = #selector(sortButtonTapped)
        sortButton.tintColor = .black
        
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func loadIndicatorStartAnimating() {
        loadIndicator.startAnimating()
    }
    
    private func loadIndicatorStopAnimating() {
        loadIndicator.stopAnimating()
    }
    
    @objc
    private func sortButtonTapped() {
        let alertController = UIAlertController(
            title: "Cортировка",
            message: nil,
            preferredStyle: .actionSheet
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "По названию",
                style: .default
            ) { [weak self] _ in
                self?.viewModel.sortByName()
            }
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "По количеству NFT",
                style: .default
            ) { [weak self] _ in
                self?.viewModel.sortByNFTsCount()
            }
        )
        
        alertController.addAction(
            UIAlertAction(
                title: "Закрыть",
                style: .cancel
            )
        )
        
        present(alertController, animated: true)
    }
}

// MARK: UITableViewDataSource

extension CatalogViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CatalogTableViewCell.reuseIdentifier,
            for: indexPath
        ) as? CatalogTableViewCell else {
            return UITableViewCell()
        }
        
        let collection = collections[indexPath.row]
        
        if let imageURLString = collection.cover,
           let imageURL = URL(string: imageURLString.encodeURL) {
            cell.itemImageView.kf.setImage(with: imageURL)
        }
        
        cell.nameLabel.text = collection.name + "(\(collection.nfts.count))"
        cell.selectionStyle = .none
        return cell
    }
}

// MARK: UITableViewDelegate

extension CatalogViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        179
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?
            .pushViewController(
                CollectionViewController(
                    viewModel: CollectionViewModel(
                        collection: collections[indexPath.row]
                    )
                ),
                animated: true
            )
    }
}
