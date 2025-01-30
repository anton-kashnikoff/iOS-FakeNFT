//
//  Float+Extensions.swift
//  FakeNFT
//
//  Created by Andy Kruch on 17.10.23.
//

import Foundation

extension Double {
    var ethCurrency: String {
        let formater = NumberFormatter()
        formater.numberStyle = .currency
        formater.locale = Locale(identifier: "es_ES")
        formater.currencySymbol = "ETH"
        return formater.string(from: NSNumber(value: self)) ?? String()
    }
}
