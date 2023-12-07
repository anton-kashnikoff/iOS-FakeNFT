//
//  CurrencyCell.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 17.10.2023.
//

import UIKit

final class CurrencyCell: UICollectionViewCell, ReuseIdentifying {
    private(set) var currency: Currency? = nil {
        didSet {
            changeCurrency()
        }
    }
    private let insets = UIEdgeInsets(top: 4,
                                      left: 12,
                                      bottom: 4,
                                      right: 12)
    
    //MARK: - UI elements
    private lazy var currencyLogoView: UIImageView = {
        let logoView = UIImageView()
        logoView.image = nil
        logoView.contentMode = .scaleAspectFill
        logoView.backgroundColor = .ypBlack
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = CornerRadius.small.cgFloat()
        logoView.translatesAutoresizingMaskIntoConstraints = false
        return logoView
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var fullTitleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .ypBlack
        title.font = .Regular.small
        return title
    }()
    
    private lazy var shortTitleLabel: UILabel = {
        let title = UILabel()
        title.textColor = .greenUniversal
        title.font = .Regular.small
        return title
    }()
    
    //MARK: - Handle selection
    override var isSelected: Bool {
        didSet {
            backgroundView?.layer.borderWidth = isSelected ? 1 : 0
        }
    }
    
    //MARK: - Configure cell
    func configureCell(for currency: Currency?) {
        setupUI()
        self.currency = currency
    }
    
    private func setupUI() {
        accessibilityIdentifier = "currency_cell"
        
        backgroundColor = .clear
        backgroundView = UIView(frame: frame)
        backgroundView?.layer.borderColor = UIColor.ypBlack.cgColor
        backgroundView?.backgroundColor = .ypLightGrey
        backgroundView?.clipsToBounds = true
        backgroundView?.layer.cornerRadius = 12
        
        [currencyLogoView,
         titleStack].forEach{
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            currencyLogoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            currencyLogoView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            currencyLogoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom),
            currencyLogoView.widthAnchor.constraint(equalTo: currencyLogoView.heightAnchor)
        ])
        
        titleStack.addArrangedSubview(fullTitleLabel)
        titleStack.addArrangedSubview(shortTitleLabel)
        NSLayoutConstraint.activate([
            titleStack.leadingAnchor.constraint(equalTo: currencyLogoView.trailingAnchor, constant: 4),
            titleStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            titleStack.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            titleStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom)
        ])
        
    }
    
    private func changeCurrency() {
        shortTitleLabel.text = currency?.name ?? "TST"
        fullTitleLabel.text = currency?.title ?? "Test"
        if let imageURLString = currency?.image {
            currencyLogoView.kf.setImage(with: URL(string: imageURLString)!,
                                   options: [.transition (.fade (0.3))])
        }
    }
}

