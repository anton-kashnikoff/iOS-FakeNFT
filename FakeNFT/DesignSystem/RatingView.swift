//
//  RatingView.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import UIKit

final class RatingView: UIView {
    private var rating: UInt = 0 {
        didSet {
            stars.forEach { star in
                changeStarStatus(star: star, isActive: !(rating < star.tag))
            }
        }
    }
    
    private lazy var stars = getStarsView()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func getStarsView() -> [UIImageView] {
        var result: [UIImageView] = []
        for index in 1...5 {
            let star = UIImageView()
            star.tag = index
            result.append(star)
        }
        return result
    }
    
    //MARK: - Set rating (0 to 5 stars)
    func setRating(to newRating: UInt) {
        rating = newRating
    }
    
    private func changeStarStatus(star: UIImageView, isActive: Bool) {
        star.image = UIImage(named: isActive ? "Star_Active" : "Star_Inactive")
    }
    
    private func setupUI() {
        let starStack = UIStackView()
        starStack.axis = .horizontal
        starStack.distribution = .equalSpacing
        stars.forEach { star in
            star.heightAnchor.constraint(equalToConstant: 12).isActive = true
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starStack.addArrangedSubview(star)
            star.translatesAutoresizingMaskIntoConstraints = false
        }
        addSubview(starStack)
        starStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            starStack.heightAnchor.constraint(equalToConstant: 12),
            starStack.widthAnchor.constraint(equalToConstant: 68),
            starStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            starStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

}
