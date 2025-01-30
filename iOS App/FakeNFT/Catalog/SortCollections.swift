//
//  SortCollections.swift
//  FakeNFT
//
//  Created by Andy Kruch on 14.10.23.
//

import Foundation

enum SortNFTsCollectionType: String {
    case byName
    case byNFTsCount
}

final class SortNFTsCollections {
    func getSortValue() -> String {
        UserDefaults.standard.string(forKey: "Sort") ?? String()
    }
    
    func setSortValue(value: String) {
        UserDefaults.standard.set(value, forKey: "Sort")
    }
}
