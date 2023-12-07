//
//  MockCurrency.swift
//  FakeNFTTests
//
//  Created by Aleksey Yakushev on 26.10.2023.
//

@testable import FakeNFT
import Foundation

struct MockCurrency {
    static let currency1 = Currency(title: "Currency 1",
                                    name: "CUR1",
                                    image: "",
                                    id: "1")
    static let currency2 = Currency(title: "Currency 2",
                                    name: "CUR2",
                                    image: "",
                                    id: "2")
    static let currency3 = Currency(title: "Currency 3",
                                    name: "CUR3",
                                    image: "",
                                    id: "3")
    static let currencyList = [currency1, currency2, currency3]
}
