//
//  WebViewModel.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 22.10.2023.
//

import Foundation

final class WebViewModel {
    // MARK: - Private Properties
    
    private let url: URL
    
    // MARK: - Public Properties
    
    var makeRequest: URLRequest {
        URLRequest(url: url)
    }
    
    // MARK: - init()
    
    init(url: String) {
        if let realURL = URL(string: url) {
            self.url = realURL
        } else {
            self.url = URL(string: "https://ya.ru/")!
            assertionFailure("Not a valid URL")
        }
    }
}
