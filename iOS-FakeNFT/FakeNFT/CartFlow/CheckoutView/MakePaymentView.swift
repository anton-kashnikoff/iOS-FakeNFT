//
//  MakePaymentView.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 17.10.2023.
//

import UIKit

final class MakePaymentView: UIView {
    // MARK: - Private Properties
    
    private let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private var paymentAction: () -> Void = {}
    private var agreementAction: () -> Void = {}
    
    // MARK: - UI-elements
    
    private lazy var payButton: GenericButton = {
        let payButton = GenericButton(type: .system)
        payButton.setTitle(
            NSLocalizedString("paymentView.payButton", tableName: "CartFlowStrings", comment: "Оплатить"),
            for: .normal
        )
        
        payButton.titleLabel?.font = .Bold.small
        payButton.layer.cornerRadius = CornerRadius.big.rawValue
        payButton.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        payButton.switchActiveState(isActive: false)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        return payButton
    }()
    
    private lazy var userAgreementButton: UIButton = {
        let agreementButton = UIButton(type: .system)
        agreementButton.tintColor = .blueUniversal
        agreementButton.setTitle(
            NSLocalizedString("paymentView.userAgreementButton", tableName: "CartFlowStrings", comment: "Пользовательского соглашения"),
            for: .normal
        )
        
        agreementButton.addTarget(self, action: #selector(agreementButtonTapped), for: .touchUpInside)
        agreementButton.titleLabel?.font = .Regular.small
        agreementButton.backgroundColor = .clear
        agreementButton.contentHorizontalAlignment = .left
        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        agreementButton.accessibilityIdentifier = "agreement"
        return agreementButton
    }()
    
    private lazy var disclaimerLabel: UILabel = {
        let disclaimerLabel = UILabel()
        disclaimerLabel.text = NSLocalizedString(
            "paymentView.disclaimerLabel",
            tableName: "CartFlowStrings",
            comment: "Совершая покупку, вы соглашаетесь с условиями"
        )

        disclaimerLabel.textColor = .ypBlack
        disclaimerLabel.font = .Regular.small
        disclaimerLabel.backgroundColor = .clear
        disclaimerLabel.textAlignment = .left
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        return disclaimerLabel
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
    
    @objc
    private func agreementButtonTapped() {
        agreementAction()
    }
    
    @objc
    private func payButtonTapped() {
        paymentAction()
    }
    
    // MARK: - Public Methods
    
    func setPaymentAction(action: @escaping () -> Void) {
        paymentAction = action
    }
    
    func setAgreementAction(action: @escaping () -> Void) {
        agreementAction = action
    }
    
    func setupUI() {
        backgroundColor = .ypLightGrey
        clipsToBounds = true
        layer.cornerRadius = 12
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        [payButton, userAgreementButton, disclaimerLabel].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            payButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            payButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            payButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom),
            payButton.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        NSLayoutConstraint.activate([
            userAgreementButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            userAgreementButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            userAgreementButton.bottomAnchor.constraint(equalTo: payButton.topAnchor, constant: -insets.top)
        ])
        
        NSLayoutConstraint.activate([
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            disclaimerLabel.bottomAnchor.constraint(equalTo: userAgreementButton.topAnchor),
            disclaimerLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets.top)
        ])
    }
    
    func switchPayButtonState(isActive: Bool) {
        payButton.switchActiveState(isActive: isActive)
    }
}
