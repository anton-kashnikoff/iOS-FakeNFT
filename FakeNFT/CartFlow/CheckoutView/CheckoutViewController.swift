//
//  CheckoutViewController.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 15.10.2023.
//

import UIKit

final class CheckoutViewController: UIViewController {
    private let viewModel: CheckoutViewModel
    private var router: CartFlowRouterProtocol
    
    private lazy var paymentView: MakePaymentView = {
        let paymentView = MakePaymentView()
        paymentView.translatesAutoresizingMaskIntoConstraints = false
        return paymentView
    }()
    
    private lazy var currencyCollection: UICollectionView = {
        let currencyCollection = UICollectionView(frame: CGRect(),
                                                  collectionViewLayout: UICollectionViewLayout())
        return currencyCollection
    }()
    
    //MARK: - Lifecycle
    init(viewModel: CheckoutViewModel = CheckoutViewModel(), router: CartFlowRouterProtocol = CartFlowRouter.shared) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.router.checkoutVC = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.$currencyList.makeBinding(action: { [weak self] _ in
            DispatchQueue.main.async {
                self?.currencyListUpdated()
            }
        })
        
        initialSetup()
    }
    
    //MARK: - Initial setup
    private func initialSetup() {
        setupUI()
        viewModel.getCurrencyList()
        UIBlockingProgressHUD.show()
    }
    
    //MARK: - UI setup
    private func setupUI() {
        view.backgroundColor = .ypWhite
        navigationItem.title = NSLocalizedString("checkoutView.paymentMethod",
                                                 tableName: "CartFlow",
                                                 comment: "Выберете способ оплаты")
        let backButton = UIBarButtonItem(image: UIImage(named: "Backward"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(backButtonTapped))
        backButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(paymentView)
        NSLayoutConstraint.activate([
            paymentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        paymentView.setPaymentAction { [weak self] in
            self?.payButtonTapped()
            self?.dismiss(animated: true)
        }
        paymentView.setAgreementAction { [weak self] in
            self?.agreementButtonTapped()
        }
        setupCollection()
    }
    
    private func setupCollection() {
        let layout = UICollectionViewFlowLayout()
        currencyCollection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        currencyCollection.backgroundColor = .clear
        currencyCollection.dataSource = self
        currencyCollection.delegate = self
        currencyCollection.contentInset = UIEdgeInsets(top: 20,
                                                       left: 16,
                                                       bottom: 20,
                                                       right: 16)
        currencyCollection.register(CurrencyCell.self)
        view.addSubview(currencyCollection)
        currencyCollection.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currencyCollection.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            currencyCollection.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            currencyCollection.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            currencyCollection.bottomAnchor.constraint(equalTo: paymentView.topAnchor)
        ])
    }
    
    //MARK: - Handle updates from model
    private func currencyListUpdated() {
        self.currencyCollection.reloadData()
        UIBlockingProgressHUD.dismiss()
    }
    
    //MARK: - Navigation
    
    private func payButtonTapped() {
        viewModel.makePayment()
    }
    
    private func agreementButtonTapped() {
        router.showAgreementWebView()
    }
    
    @objc private func backButtonTapped() {
        router.pop(vc: self)
    }
}

//MARK: - CollectionViewDelegates
extension CheckoutViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        let currency = viewModel.currencyList[indexPath.row]
        viewModel.setCurrencyTo(id: currency.id)
        paymentView.switchPayButtonState(isActive: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        7
    }
}

extension CheckoutViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.width - 7) / 2  - collectionView.contentInset.left
        return CGSize(width: cellWidth, height: 46)
    }
}

//MARK: - CollectionViewDataSource
extension CheckoutViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        viewModel.currencyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CurrencyCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let currency = viewModel.currencyList[indexPath.row]
        cell.configureCell(for: currency)
        return cell
    }
}
