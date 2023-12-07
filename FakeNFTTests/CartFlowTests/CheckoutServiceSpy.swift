//
//  CheckoutServiceSpy.swift
//  FakeNFTTests
//
//  Created by Aleksey Yakushev on 26.10.2023.
//

import Foundation
@testable import FakeNFT

protocol CheckoutServiceSpyProtocol {
    var payedWithCurrencyID: String {get}
    var getAllCurrenciesCalled: Bool {get}
    func reset()
}

final class CheckoutServiceSpy: CheckoutServiceProtocol {
    var checkoutVM: FakeNFT.CheckoutViewModel?
    var currencyList: [FakeNFT.Currency] = []
    
    private(set) var payedWithCurrencyID: String = ""
    private(set) var getAllCurrenciesCalled: Bool = false
    
    init(viewModel: FakeNFT.CheckoutViewModel? = nil) {
        self.checkoutVM = viewModel
    }
    
    func payWith(currecyID: String) {
        payedWithCurrencyID = currecyID
    }
    
    func getAllCurrencies() {
        getAllCurrenciesCalled = true
    }
    
    func retry() {
        
    }
}

extension CheckoutServiceSpy: CheckoutServiceSpyProtocol {
    func reset() {
        payedWithCurrencyID = ""
        getAllCurrenciesCalled = false
    }
}
