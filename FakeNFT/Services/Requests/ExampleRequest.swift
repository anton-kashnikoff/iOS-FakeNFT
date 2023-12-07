import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL?
    var id: String
    var httpMethod: HttpMethod
    var dto: Encodable?
    
    init(id: String, httpMethod: HttpMethod = .get, dto: Encodable? = nil) {
        self.id = id
        self.httpMethod = httpMethod
        self.dto = dto
        endpoint = URL(string: "\(Config.baseUrl)profile/\(self.id)")
    }
}

struct NFTsExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(Config.baseUrl)nft")
    }
    
    var httpMethod: HttpMethod = .get
}

struct UsersExampleRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(Config.baseUrl)users")
    }
    
    var httpMethod: HttpMethod = .get
}
