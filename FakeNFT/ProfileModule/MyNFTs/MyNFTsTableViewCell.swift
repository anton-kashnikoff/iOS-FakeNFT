//
//  MyNFTsTableViewCell.swift
//  FakeNFT
//
//  Created by Антон Кашников on 19/10/2023.
//

import UIKit

final class MyNFTsTableViewCell: UITableViewCell {
    // MARK: - Static properties
    
    static let reuseIdentifier = "NFTCell"
    
    // MARK: - UI-elements

    let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "NFT_Placeholder")
        imageView.layer.cornerRadius = 12
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nftLikeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Favorites_Inactive"), for: .normal)
        return button
    }()
    
    private let containerView = UIView()
    
    private let nftNameLabel: UILabel = {
       let label = UILabel()
        label.text = "Lilo"
        label.font = UIFont.Bold.small
        return label
    }()
    
    private let ratingView: RatingView = {
        let ratingView = RatingView()
        ratingView.setRating(to: 4)
        return ratingView
    }()
    
    private let nftAuthorLabel: UILabel = {
       let label = UILabel()
        label.text = "от John Doe"
        label.font = UIFont.Regular.small
        return label
    }()
    
    private let priceTitleLabel: UILabel = {
       let label = UILabel()
        label.text = "Цена"
        label.font = UIFont.Regular.small
        return label
    }()
    
    private let priceLabel: UILabel = {
       let label = UILabel()
        label.text = "1,78 ETH"
        label.font = UIFont.Bold.small
        return label
    }()
    
    // MARK: - Public properties
    
    var buttonTappedHandler: (() -> Void)?
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        setupNFTImageView()
        setupNFTLikeButton()
        setupContainerView()
        setupNFTNameLabel()
        setupRatingView()
        setupNFTAuthorLabel()
        setupPriceTitleLabel()
        setupPriceLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func updateNameLabel(_ string: String) {
        nftNameLabel.text = string
    }
    
    func updateRating(_ int: Int) {
        ratingView.setRating(to: UInt(int))
    }
    
    func updatePrice(_ price: Double) {
        priceLabel.text = "\(price) ETH"
    }
    
    func updateAuthor(_ author: String) {
        nftAuthorLabel.text = "от \(author)"
    }
    
    func updateLike(_ isLiked: Bool) {
        if isLiked {
            nftLikeButton.setImage(UIImage(named: "Favorites_Active"), for: .normal)
        } else {
            nftLikeButton.setImage(UIImage(named: "Favorites_Inactive"), for: .normal)
        }
    }
    
    // MARK: - Private methods
    
    private func setupView() {
        [
            nftImageView,
            nftLikeButton,
            containerView,
            nftNameLabel,
            ratingView,
            nftAuthorLabel,
            priceTitleLabel,
            priceLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupNFTImageView() {
        contentView.addSubview(nftImageView)
        
        NSLayoutConstraint.activate([
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupNFTLikeButton() {
        nftLikeButton.addTarget(self, action: #selector(likeButtonDidTap(_:)), for: .touchUpInside)
        nftImageView.addSubview(nftLikeButton)
        
        NSLayoutConstraint.activate([
            nftLikeButton.widthAnchor.constraint(equalToConstant: 42),
            nftLikeButton.heightAnchor.constraint(equalToConstant: 42),
            nftLikeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            nftLikeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor)
        ])
    }
    
    private func setupContainerView() {
        contentView.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 62),
            containerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: nftImageView.trailingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -39)
        ])
    }
    
    private func setupNFTNameLabel() {
        containerView.addSubview(nftNameLabel)
        
        NSLayoutConstraint.activate([
            nftNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nftNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
    }
    
    private func setupRatingView() {
        containerView.addSubview(ratingView)
        
        NSLayoutConstraint.activate([
            ratingView.widthAnchor.constraint(equalToConstant: 68),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            ratingView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            ratingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
    }
    
    private func setupNFTAuthorLabel() {
        containerView.addSubview(nftAuthorLabel)
        
        NSLayoutConstraint.activate([
            nftAuthorLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            nftAuthorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
    }
    
    private func setupPriceTitleLabel() {
        containerView.addSubview(priceTitleLabel)
        
        NSLayoutConstraint.activate([
            priceTitleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            priceTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 117)
        ])
    }
    
    private func setupPriceLabel() {
        containerView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: priceTitleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: priceTitleLabel.leadingAnchor)
        ])
    }
    
    @objc
    private func likeButtonDidTap(_ sender: UIButton) {
        buttonTappedHandler?()
    }
}
