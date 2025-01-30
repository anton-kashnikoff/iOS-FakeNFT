//
//  CartTotalView.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import UIKit

final class CartTotalView: UIView {
    // MARK: - Private Properties
    
    private let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private var quantity = Int.zero {
        didSet {
            quantityLabel.text = "\(quantity) NFT"
        }
    }
    
    private var price = "?" {
        didSet {
            totalPriceLabel.text = price + " ETH"
        }
    }
    
    private var checkoutAction: () -> Void = {}
    
    private lazy var quantityLabel: UILabel = {
        let quantityLabel = UILabel()
        quantityLabel.text = "\(quantity) NFT"
        quantityLabel.font = .Regular.medium
        quantityLabel.textColor = .ypBlack
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        return quantityLabel
    }()
    
    private lazy var totalPriceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.text = "\(price) ETH"
        priceLabel.font = .Bold.small
        priceLabel.textColor = .greenUniversal
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        return priceLabel
    }()
    
    // MARK: - Public Properties
    
    lazy var payButton: GenericButton = {
        let button = GenericButton(type: .system)
        button.setTitle("К оплате", for: .normal)
        button.titleLabel?.font = .Bold.small
        button.layer.cornerRadius = CornerRadius.big.rawValue
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "pay_button"
        return button
    }()
    
    // MARK: - init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupUI() {
        backgroundColor = .ypLightGrey
        
        [payButton, quantityLabel, totalPriceLabel].forEach {
            addSubview($0)
        }
    
        NSLayoutConstraint.activate([
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            payButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(insets.bottom)),
            payButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -(insets.right))
        ])
        
        NSLayoutConstraint.activate([
            quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            quantityLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        ])
        
        NSLayoutConstraint.activate([
            totalPriceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            totalPriceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(insets.bottom))
        ])
    }
    
    @objc
    private func payButtonTapped() {
        checkoutAction()
    }
    
    // MARK: - Public Methods
    
    func setQuantity(_ newQuantity: Int) {
        quantity = newQuantity
    }
    
    func setTotalprice(_ newPrice: Double) {
        price = String(format: "%.2f", newPrice)
    }
    
    func setCheckoutAction(_ action: @escaping () -> Void) {
        checkoutAction = action
    }
}
