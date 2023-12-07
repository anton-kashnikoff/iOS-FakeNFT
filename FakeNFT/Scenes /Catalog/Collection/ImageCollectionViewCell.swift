//
//  ImageCollectionViewCell.swift
//  FakeNFT
//
//  Created by Andy Kruch on 11.10.23.
//

import UIKit

final class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCell"
    
    var collectionImageTapped: (() -> Void)?
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [imageView].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    @objc private func collectionCellTapped() {
        collectionImageTapped?()
    }
    
    func configure(
        collectionImageAction: @escaping() -> Void
    ) {
        collectionImageTapped = collectionImageAction
    }
}


