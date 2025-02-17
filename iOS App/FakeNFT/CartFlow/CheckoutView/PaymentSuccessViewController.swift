//
//  PaymentSuccessViewController.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 22.10.2023.
//

import UIKit

final class PaymentSuccessViewController: UIViewController {
    // MARK: - Private Properties
    
    private let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private lazy var successImageView: UIImageView = {
        let image = UIImage(named: "Payment_Success")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.heightAnchor.constraint(equalToConstant: 278).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
       let label = UILabel()
        label.textColor = .ypBlack
        label.font = .Bold.medium
        label.text = NSLocalizedString("successView.label", tableName: "CartFlowStrings", comment: "Успех")
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var successStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var returnButton: UIButton = {
        let button = GenericButton(type: .system)
        button.setTitle(
            NSLocalizedString(
                "successView.back",
                tableName: "CartFlowStrings",
                comment: "Вернуться в каталог"
            ),
            for: .normal
        )
        
        button.titleLabel?.font = .Bold.small
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var returnAction: () -> Void = {}
    
    // MARK: - Public Properties
    
    var router = CartFlowRouter.shared
    
    // MARK: - UIViewController
    
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    // MARK: - Private Methods

    private func setupUI() {
        view.backgroundColor = .ypWhite
        setNeedsStatusBarAppearanceUpdate()
        
        view.addSubview(successStack)
        successStack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        successStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        successStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        successStack.addArrangedSubview(successImageView)
        successStack.addArrangedSubview(successLabel)
        
        view.addSubview(returnButton)
        NSLayoutConstraint.activate([
            returnButton.heightAnchor.constraint(equalToConstant: 60),
            returnButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            returnButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            returnButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    @objc
    private func returnButtonTapped() {
        router.backToCatalog()
    }
}
