//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import UIKit

enum CartSortOrder: String {
    case price, rating, title
}

final class CartViewController: UIViewController {
    // MARK: - Private Propertiea
    
    private let viewModel: CartViewModel
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private var router: CartFlowRouterProtocol
    
    // MARK: - UI-elements
    
    private lazy var cartTable: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CartItemCell.self)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()
    
    private lazy var paymentView: CartTotalView = {
        let view = CartTotalView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emptyCartLabel: UILabel = {
       let label = UILabel()
        label.textColor = .ypBlack
        label.font = .Bold.small
        label.text = NSLocalizedString("cart.empty", tableName: "CartFlowStrings", comment: "Корзина пуста")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - UIViewController
    
    init(viewModel: CartViewModel = CartViewModel(), router: CartFlowRouterProtocol = CartFlowRouter.shared) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.router.cartVC = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.$currentOrderSorted.makeBinding { [weak self] _ in
            DispatchQueue.main.async {
                self?.orderUpdated()
            }
        }
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tabBarController {
            if tabBarController.selectedIndex != 2 {
                // The view controller is appearing after switching tabs
                viewModel.getOrder()
                showProgressView()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func initialSetup() {
        setupUI()
        checkIfEmpty()
        viewModel.getOrder()
        showProgressView()
    }

    private func setupUI() {
        [emptyCartLabel, paymentView, cartTable].forEach {
            view.addSubview($0)
        }
        
        // Empty label
        NSLayoutConstraint.activate([
            emptyCartLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyCartLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Sort button
        let sortButton = UIBarButtonItem(
            image: UIImage(resource: .sortButton),
            style: .plain,
            target: self,
            action: #selector(sortButtonTapped)
        )
        
        sortButton.tintColor = .ypBlack
        sortButton.accessibilityIdentifier = "sort_button"
        navigationItem.rightBarButtonItem = sortButton
        
        // Payment view
        NSLayoutConstraint.activate([
            paymentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            paymentView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            paymentView.heightAnchor.constraint(equalToConstant: 76)
        ])
        
        paymentView.setCheckoutAction { [weak self] in
            self?.payButtonTapped()
        }
    
        // Cart item table
        cartTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cartTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cartTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cartTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cartTable.bottomAnchor.constraint(equalTo: paymentView.topAnchor)
        ])
        
        cartTable.refreshControl = {
            let control = UIRefreshControl()
            control.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
            return control
        }()
    }
    
    private func checkIfEmpty() {
        paymentView.isHidden = viewModel.currentOrderSorted.isEmpty
        cartTable.isHidden = viewModel.currentOrderSorted.isEmpty
        emptyCartLabel.isHidden = !viewModel.currentOrderSorted.isEmpty
    }
    
    private func hideProgressView() {
        UIBlockingProgressHUD.dismiss()
    }
    
    private func payButtonTapped() {
        router.showPaymentScreen()
    }

    @objc
    private func sortButtonTapped() {
        router.showSortSheet()
    }
    
    @objc
    private func pullToRefresh() {
        viewModel.getOrder()
    }
    
    // MARK: - Public Methods
    
    func orderUpdated() {
        paymentView.setQuantity(viewModel.currentOrderSorted.count)
        paymentView.setTotalprice(
            viewModel.currentOrderSorted.reduce(.zero) { $0 + $1.price }
        )
        
        cartTable.reloadData()
        cartTable.refreshControl?.endRefreshing()
        checkIfEmpty()
        hideProgressView()
    }
    
    func showProgressView() {
        UIBlockingProgressHUD.show()
    }
    
    func setSorting(to newSortingStyle: CartSortOrder) {
        viewModel.setSortingStyle(to: newSortingStyle)
    }
}

// MARK: - UITableViewDelegate

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

// MARK: - UITableViewDataSource

extension CartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentOrderSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CartItemCell = tableView.dequeueReusableCell()
        cell.setupCellUI()
        cell.delegate = viewModel
        cell.configureCellFor(nft: viewModel.currentOrderSorted[indexPath.row])
        return cell
    }
}
