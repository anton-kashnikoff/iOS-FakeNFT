//
//  MakePaymentView.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 17.10.2023.
//

import UIKit

final class MakePaymentView: UIView {
    private let insets = UIEdgeInsets(top: 16,
                                      left: 16,
                                      bottom: 16,
                                      right: 16)
    
    //MARK: - UI elements
    private lazy var payButton: GenericButton = {
        let payButton = GenericButton(type: .system)
        let title = NSLocalizedString("paymentView.payButton",
                                      tableName: "CartFlow",
                                      comment: "Оплатить")
        payButton.setTitle(title,
                           for: .normal)
        payButton.titleLabel?.font = .Bold.small
        payButton.layer.cornerRadius = CornerRadius.big.cgFloat()
        payButton.addTarget(self,
                            action: #selector(payButtonTapped),
                            for: .touchUpInside)
        payButton.switchActiveState(isActive: false)
        payButton.translatesAutoresizingMaskIntoConstraints = false
        return payButton
    }()
    
    private lazy var userAgreementButton: UIButton = {
        let agreementButton = UIButton(type: .system)
        agreementButton.tintColor = .blueUniversal
        let title = NSLocalizedString("paymentView.userAgreementButton",
                                      tableName: "CartFlow",
                                      comment: "Пользовательского соглашения")
        agreementButton.setTitle(title,
                                 for: .normal)
        agreementButton.addTarget(self, action:
                                    #selector(agreementButtonTapped),
                                  for: .touchUpInside)
        agreementButton.titleLabel?.font = .Regular.small
        agreementButton.backgroundColor = .clear
        agreementButton.contentHorizontalAlignment = .left
        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        agreementButton.accessibilityIdentifier = "agreement"
        return agreementButton
    }()
    
    private lazy var disclaimerLabel: UILabel = {
        let disclaimerLabel = UILabel()
        let text = NSLocalizedString("paymentView.disclaimerLabel",
                                     tableName: "CartFlow",
                                     comment: "Совершая покупку, вы соглашаетесь с условиями")
        disclaimerLabel.text = text
        disclaimerLabel.textColor = .ypBlack
        disclaimerLabel.font = .Regular.small
        disclaimerLabel.backgroundColor = .clear
        disclaimerLabel.textAlignment = .left
        disclaimerLabel.translatesAutoresizingMaskIntoConstraints = false
        return disclaimerLabel
    }()
    
    private var paymentAction: () -> Void = { }
    private var agreementAction: () -> Void = { }

    //MARK: - Lifecycle
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI setup
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
        
        [payButton,
         userAgreementButton,
         disclaimerLabel].forEach{
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
    
    //MARK: - Button interaction
    func switchPayButtonState(isActive: Bool) {
        payButton.switchActiveState(isActive: isActive)
    }
    
    @objc private func agreementButtonTapped() {
        agreementAction()
    }
    
    @objc private func payButtonTapped() {
        paymentAction()
    }
}
