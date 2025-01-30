//
//  CartItemCell.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import Kingfisher
import UIKit

protocol CartItemCellDelegate {
    func removeItem(id: String)
}

final class CartItemCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Private Properties
    
    private let insets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    
    private let nftPreview: UIImageView = {
        let nftView = UIImageView()
        nftView.contentMode = .scaleAspectFill
        nftView.clipsToBounds = true
        nftView.layer.cornerRadius = CornerRadius.big.rawValue
        nftView.translatesAutoresizingMaskIntoConstraints = false
        return nftView
    }()
    
    private let ratingView = RatingView()
    
    private let titleLabel: UILabel = {
       let title = UILabel()
        title.textColor = .ypBlack
        title.font = .Bold.small
        title.text = "Title"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let priceHeaderLabel: UILabel = {
        let priceHeader = UILabel()
        priceHeader.textColor = .ypBlack
        priceHeader.font = .Regular.small
        priceHeader.text = NSLocalizedString(
            "cartItem.priceLabel",
            tableName: "CartFlowStrings",
            comment: "Цена"
        )
        priceHeader.translatesAutoresizingMaskIntoConstraints = false
        return priceHeader
    }()
    
    private let priceLabel: UILabel = {
       let price = UILabel()
        price.textColor = .ypBlack
        price.font = .Bold.small
        price.text = "1,23 ETH"
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    private var nft: ItemNFT?
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(resource: .cartDelete), for: .normal)
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        button.tintColor = .ypBlack
        button.adjustsImageWhenHighlighted = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = "remove_item_button"
        return button
    }()
    
    // MARK: - Public Properties
    
    var delegate: CartItemCellDelegate?
    
    // MARK: - Private Methods
    
    private func setPrice(_ price: Double) {
        priceLabel.text = "\(price) ETH"
    }
    
    private func setRating(_ rating: UInt) {
        ratingView.setRating(to: rating)
    }
    
    private func setName(_ name: String) {
        titleLabel.text = name
    }
    
    private func setPreviewImage(_ imageURLString: String?) {
        if let imageURLString {
            nftPreview.kf
                .setImage(
                    with: URL(string: imageURLString)!,
                    placeholder: UIImage(named: "NFT_Placeholder"),
                    options: [.transition(.fade(0.3))]
                )
        }
    }
    
    @objc
    private func removeButtonTapped() {
        CartFlowRouter.shared.showDeleteConfirmationForNFT(
            nft,
            removalAction: removeItem
        )
    }
    
    // MARK: - Public Methods
    
    func setupCellUI() {
        selectionStyle = .none
        backgroundColor = .clear
        isUserInteractionEnabled = true
        contentView.isHidden = true
        accessibilityIdentifier = "cart_item_cell"
        
        [
            nftPreview,
            removeButton,
            titleLabel,
            ratingView,
            priceLabel,
            priceHeaderLabel
        ].forEach {
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            nftPreview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            nftPreview.centerYAnchor.constraint(equalTo: centerYAnchor),
            nftPreview.heightAnchor.constraint(equalToConstant: 108),
            nftPreview.widthAnchor.constraint(equalToConstant: 108)
        ])
        
        NSLayoutConstraint.activate([
            removeButton.heightAnchor.constraint(equalToConstant: 44),
            removeButton.widthAnchor.constraint(equalToConstant: 44),
            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: insets.top + 8)
        ])
        
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.widthAnchor.constraint(equalToConstant: 68)
        ])
        ratingView.setRating(to: 4)
        
        NSLayoutConstraint.activate([
            priceLabel.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            priceLabel.trailingAnchor.constraint(equalTo: removeButton.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -(insets.bottom) - 8)
        ])
        
        NSLayoutConstraint.activate([
            priceHeaderLabel.leadingAnchor.constraint(equalTo: nftPreview.trailingAnchor, constant: 20),
            priceHeaderLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor, constant: -2)
        ])
    }
    
    func configureCellFor(nft: ItemNFT) {
        self.nft = nft
        setPrice(nft.price)
        setName(nft.name)
        setRating(UInt(nft.rating))
        setPreviewImage(nft.images.first)
    }
}

extension CartItemCell {
    func removeItem() {
        delegate?.removeItem(id: nft?.id ?? String())
        
        DispatchQueue.main.async { [weak self] in
            self?.isUserInteractionEnabled = false
            
            UIView
                .animate(withDuration: 0.25, delay: .zero) {
                    self?.alpha = 0.2
                } completion: { _ in
                    UIView
                        .animate(withDuration: 0.55, delay: .zero, options: [.autoreverse, .repeat]) {
                            self?.alpha = 0.5
                        }
                }
        }
    }
}
