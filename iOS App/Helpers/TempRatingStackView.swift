import UIKit

final class TempRatingStackView: UIStackView {
    // MARK: - Private Properties
    
    private let fillStarImage: UIImage? = UIImage(resource: .starFilled)
    private let emptyStarImage: UIImage? = UIImage(resource: .star)
    
    // MARK: - init()
    
    init(rating: Int = 5) {
        super.init(frame: .zero)
        
        axis = .horizontal
        spacing = 2
        translatesAutoresizingMaskIntoConstraints = false
        
        (1...rating).forEach {
            let imageView = UIImageView()
            imageView.image = emptyStarImage
            imageView.tag = $0
            addArrangedSubview(imageView)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func setupRating(rating: Int) {
        subviews.forEach {
            if let imageView = $0 as? UIImageView {
                imageView.image = imageView.tag > rating ? emptyStarImage : fillStarImage
            }
        }
    }
}
