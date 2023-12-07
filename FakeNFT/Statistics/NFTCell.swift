import Kingfisher
import UIKit

final class NFTCell: UICollectionViewCell {
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .ypLightGrey
        button.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var cartButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cart"), for: .normal)
        button.tintColor = .ypBlack
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var imageBackground: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .ypWhite
        return view
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .ypBlack
        label.font = .Medium.medium
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingView = RatingStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil)
    }
}

extension NFTCell {
    func configure(with nft: ItemNFT?) {
        nameLabel.text = nft?.name
        nameLabel.font = .Bold.small
        ratingView.setupRating(rating: nft?.rating ?? 0)
        
        if let price = nft?.price {
            priceLabel.text = String(price) + " ETH"
        } else {
            priceLabel.text = "?"
        }
        
        guard let url = nft?.images[0], let validUrl = URL(string: url) else {return}
        let processor = RoundCornerImageProcessor(cornerRadius: 12)
        let options: KingfisherOptionsInfo = [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ]
        imageBackground.kf.setImage(with: validUrl, options: options)
    }
}

private extension NFTCell {
    @objc
    func likeTapped() {
        likeButton.setImage(UIImage(named: "heart-red"), for: .normal)
    }
}

private extension NFTCell {
    func setupConstraints() {
        contentView.addSubview(imageBackground)
        contentView.addSubview(ratingView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(cartButton)
        contentView.addSubview(priceLabel)
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            imageBackground.topAnchor.constraint(equalTo: topAnchor),
            imageBackground.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageBackground.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageBackground.heightAnchor.constraint(equalTo: widthAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.topAnchor.constraint(equalTo: imageBackground.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageBackground.trailingAnchor),
            
            ratingView.topAnchor.constraint(equalTo: imageBackground.bottomAnchor, constant: 8),
            ratingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40),
            cartButton.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            priceLabel.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
}
