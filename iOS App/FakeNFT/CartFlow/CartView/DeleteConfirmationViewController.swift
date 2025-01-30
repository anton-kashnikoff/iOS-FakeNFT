//
//  DeleteConfirmationViewController.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 16.10.2023.
//

import UIKit

final class DeleteConfirmationViewController: UIViewController {
    // MARK: - UI-elements
    
    private lazy var nftView: UIImageView = {
        let nftView = UIImageView()
        nftView.image = UIImage(named: "NFT_Placeholder")
        nftView.contentMode = .scaleAspectFill
        nftView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        nftView.widthAnchor.constraint(equalToConstant: 108).isActive = true
        nftView.clipsToBounds = true
        nftView.layer.cornerRadius = 12
        nftView.translatesAutoresizingMaskIntoConstraints = false
        return nftView
    }()
    
    private lazy var alertText: UILabel = {
        let alertText = UILabel()
        alertText.font = .Regular.small
        alertText.numberOfLines = 2
        alertText.text = NSLocalizedString(
            "deleteConfirmation.label",
            tableName: "CartFlowStrings",
            comment: "Подтверждение удаления"
        )
        
        alertText.textAlignment = .center
        alertText.textColor = .ypBlack
        alertText.translatesAutoresizingMaskIntoConstraints = false
        alertText.accessibilityIdentifier = "remove_item_alert"
        return alertText
    }()
    
    private lazy var buttonStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.widthAnchor.constraint(equalToConstant: 262).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var cancelButton: UIButton = {
        let cancelButton = GenericButton(type: .system)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.titleLabel?.font = .Regular.large
        cancelButton.setTitle(
            NSLocalizedString(
                "deleteConfirmation.cancel",
                tableName: "CartFlowStrings",
                comment: "Вернуться"
            ),
            for: .normal
        )
        
        cancelButton.layer.cornerRadius = CornerRadius.medium.rawValue
        cancelButton.accessibilityIdentifier = "remove_item_cancel"
        return cancelButton
    }()
    
    private lazy var removeButton: UIButton = {
        let removeButton = GenericButton(type: .system)
        removeButton.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        removeButton.titleLabel?.font = .Regular.large
        removeButton.setTitleColor(.redUniversal, for: .normal)
        removeButton.setTitle(
            NSLocalizedString(
                "deleteConfirmation.proceed",
                tableName: "CartFlowStrings",
                comment: "Удалить"
            ),
            for: .normal
        )
        
        removeButton.layer.cornerRadius = CornerRadius.medium.rawValue
        removeButton.accessibilityIdentifier = "remove_item_proceed"
        return removeButton
    }()
    
    // MARK: - Public Properties
    
    var removalAction: () -> Void = {}
    var nftImageURL: String? {
        didSet {
            if let url = nftImageURL {
                nftView.kf
                    .setImage(
                        with: URL(string: url)!,
                        placeholder: UIImage(resource: .nftPlaceholder),
                        options: [.transition(.fade(0.3))]
                    )
            }
        }
    }
    
    // MARK: - UIViewController
    
    override var prefersStatusBarHidden: Bool {
        true
    }

    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .clear
        setNeedsStatusBarAppearanceUpdate()
        
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.frame = view.bounds
        
        [blurEffectView, nftView, alertText, buttonStack].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nftView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            alertText.topAnchor.constraint(equalTo: nftView.bottomAnchor, constant: 12),
            alertText.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: alertText.bottomAnchor, constant: 20),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        buttonStack.addArrangedSubview(removeButton)
        buttonStack.addArrangedSubview(cancelButton)
    }
    
    @objc
    private func removeButtonTapped() {
        dismiss(animated: true, completion: removalAction)
    }
    
    @objc
    private func cancelButtonTapped() {
        dismiss(animated: true)
    }
}
