import Vapor

struct CollectionServer: Content {
    let id: Int
    let name: String
    let nfts: [String]
    let cover: String
}

struct Collection: Content {
    let createdAt: String
    let name: String
    let cover: String?
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}

struct NFT: Content {
    let createdAt: String
    let name: String
    let images: [String]
    let rating: Int
    let description: String
    let price: Double
    let id: String
}

struct User: Content {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}

struct Currency: Content {
    let title: String
    let name: String
    let image: String
    let id: String
}

struct Profile: Content {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let likes: [String]
    let id: String
}

struct Order: Content {
    let nfts: [String]
    let id: String
}

struct OrderPaymentStatus: Content {
    let success: Bool
    let id: String
    let orderId: String
}
