import Foundation

protocol NetworkTask {
    func cancel()
}

struct DefaultNetworkTask {
    let dataTask: URLSessionDataTask
}

extension DefaultNetworkTask: NetworkTask {
    func cancel() {
        dataTask.cancel()
    }
}
