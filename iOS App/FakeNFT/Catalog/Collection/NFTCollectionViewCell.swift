//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Andy Kruch on 11.10.23.
//

import UIKit
import Kingfisher

final class NFTCollectionViewCell: UICollectionViewCell {
    // MARK: - Static Properties
    
    static let identifier = "NFTCell"
    
    // MARK: - Private Properties
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(imageTapped(tapGestureRecognizer:))
            )
        )
        
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingStackView = RatingStackView()
    
    private lazy var nftNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(cartButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .ypBlack
        return button
    }()
    
    // MARK: - Public Properties
    
    var likeButtonAction: (() -> Void)?
    var cartButtonAction: (() -> Void)?
    var imageAction: (() -> Void)?
    
    // MARK: - UICollectionViewCell
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private func addSubviews() {
        [nftImageView, likeButton, ratingStackView, nftNameLabel, priceLabel, cartButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            
            likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            
            ratingStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingStackView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingStackView.heightAnchor.constraint(equalToConstant: 12),
            ratingStackView.widthAnchor.constraint(equalToConstant: 68),
            
            nftNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftNameLabel.topAnchor.constraint(equalTo: ratingStackView.bottomAnchor, constant: 5),
            nftNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -45),
            nftNameLabel.widthAnchor.constraint(equalToConstant: 68),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: nftNameLabel.bottomAnchor, constant: 4),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -29),
            priceLabel.widthAnchor.constraint(equalToConstant: 68),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -28),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    @objc
    private func likeButtonTapped() {
        likeButtonAction?()
    }
    
    @objc
    private func cartButtonTapped() {
        cartButtonAction?()
    }
    
    @objc
    private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        imageAction?()
    }
    
    // MARK: - Public Properties
    
    func configure(
        nftImage: URL,
        likeOrDislike: String,
        rating: Int,
        nftName: String,
        price: String,
        cartImage: String,
        likeButtonInteraction: @escaping () -> Void,
        cartButtonInteraction: @escaping () -> Void
    ) {
        UIBlockingProgressHUD.dismiss()
        
        nftImageView.kf.setImage(with: nftImage)
        likeButton.setImage(UIImage(named: likeOrDislike), for: .normal)
        fillRatingStackView(by: rating)
        nftNameLabel.text = nftName
        priceLabel.text = price
        cartButton.setImage(UIImage(named: cartImage), for: .normal)
        likeButtonAction = likeButtonInteraction
        cartButtonAction = cartButtonInteraction
        
        UIBlockingProgressHUD.dismiss()
    }
    
    func fillRatingStackView(by rating: Int) {
        ratingStackView.setupRating(rating: rating)
    }
}
