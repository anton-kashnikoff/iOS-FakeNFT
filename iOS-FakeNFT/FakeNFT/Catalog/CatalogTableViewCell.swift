//
//  CatalogTabelView.swift
//  FakeNFT
//
//  Created by Andy Kruch on 10.10.23.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell {
    // MARK: - Static Properties
    
    static let reuseIdentifier = "catalogCell"
    
    // MARK: - Public Properties
    
    var itemImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .blackUniversal
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - UITableViewCell
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    
    private func addSubviews() {
        [itemImageView, nameLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            itemImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            itemImageView.heightAnchor.constraint(equalToConstant: 140),
            
            nameLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -13)
        ])
    }
}
