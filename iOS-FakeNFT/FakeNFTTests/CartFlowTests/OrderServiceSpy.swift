//
//  SpyOrderService.swift
//  FakeNFTTests
//
//  Created by Aleksey Yakushev on 25.10.2023.
//

@testable import FakeNFT

protocol OrderServiceSpyProtocol {
    var removedID: String { get }
    var isGetOrderCalled: Bool { get }
    var isRretryCalled: Bool { get }
    
    func reset()
}

final class OrderServiceSpy: OrderServiceProtocol {
    private(set) var removedID = "0"
    private(set) var isGetOrderCalled = false
    private(set) var isRretryCalled = false

    var cartVM: FakeNFT.CartViewModel?
    var currentOrderItems = [FakeNFT.ItemNFT]()
    
    init(viewModel: FakeNFT.CartViewModel? = nil) {
        self.cartVM = viewModel
    }
    
    func getOrder() {
        isGetOrderCalled = true
    }
    
    func removeItemFromOrder(id: String) {
        removedID = id
    }
    
    func retry() {
        isRretryCalled = true
    }
}

extension OrderServiceSpy: OrderServiceSpyProtocol {
    func reset() {
        removedID = "0"
        isGetOrderCalled = false
        isRretryCalled = false
    }
}
