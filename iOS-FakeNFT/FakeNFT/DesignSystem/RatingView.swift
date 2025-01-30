//
//  RatingView.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import UIKit

final class RatingView: UIView {
    // MARK: - Private Properties
    
    private var rating = UInt.zero {
        didSet {
            stars.forEach { star in
                changeStarStatus(star: star, isActive: !(rating < star.tag))
            }
        }
    }
    
    private lazy var stars = getStarsView()
    
    // MARK: - init()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func getStarsView() -> [UIImageView] {
        (1...5).map { index in
            let star = UIImageView()
            star.tag = index
            return star
        }
    }
    
    private func changeStarStatus(star: UIImageView, isActive: Bool) {
        star.image = UIImage(resource: isActive ? .starActive : .starInactive)
    }
    
    private func setupUI() {
        let starStack = UIStackView()
        starStack.axis = .horizontal
        starStack.distribution = .equalSpacing
        starStack.translatesAutoresizingMaskIntoConstraints = false
        
        stars.forEach { star in
            star.heightAnchor.constraint(equalToConstant: 12).isActive = true
            star.widthAnchor.constraint(equalToConstant: 12).isActive = true
            starStack.addArrangedSubview(star)
            star.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(starStack)
        NSLayoutConstraint.activate([
            starStack.heightAnchor.constraint(equalToConstant: 12),
            starStack.widthAnchor.constraint(equalToConstant: 68),
            starStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            starStack.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    // Set rating (0 to 5 stars)
    func setRating(to newRating: UInt) {
        rating = newRating
    }
}

@available(iOS 17, *)
#Preview {
    let ratingView = RatingView()
    ratingView.setRating(to: 3)
    return ratingView
}
