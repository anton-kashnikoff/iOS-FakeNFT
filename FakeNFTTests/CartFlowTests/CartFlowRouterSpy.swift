//
//  CartFlowRouterSpy.swift
//  FakeNFTTests
//
//  Created by Aleksey Yakushev on 25.10.2023.
//

import UIKit
@testable import FakeNFT

protocol CartFlowRouterSpyProtocol {
    var isDismissCalled: Bool { get }
    var isNetworkErrorCalled: Bool { get }
    var isPaymentSuccessfullCalled: Bool { get }
    var isPaymentFailedCalled: Bool { get }
    
    func reset()
}

final class CartFlowRouterSpy: CartFlowRouterProtocol {
    var cartVC: FakeNFT.CartViewController?
    var checkoutVC: FakeNFT.CheckoutViewController?
    
    private(set) var isDismissCalled: Bool = false
    private(set) var isNetworkErrorCalled: Bool = false
    private(set) var isPaymentSuccessfullCalled: Bool = false
    private(set) var isPaymentFailedCalled: Bool = false
    
    func dismiss() {
        isDismissCalled = true
    }
    func showNetworkError(action: @escaping () -> Void) {
        isNetworkErrorCalled = true
    }
    func showPaymentError() {
        isPaymentFailedCalled = true
    }
    func paymentSuccessfull() {
        isPaymentSuccessfullCalled = true
    }
    
    func showSortSheet() { }
    func showAgreementWebView() { }
    func showPaymentScreen() { }
    func showDeleteConfirmationForNFT(_ nft: FakeNFT.ItemNFT?, removalAction: @escaping () -> Void) { }
    func pop(vc: UIViewController) { }
    func backToCatalog() { }
}

extension CartFlowRouterSpy: CartFlowRouterSpyProtocol {
    func reset() {
        isDismissCalled = false
        isNetworkErrorCalled = false
        isPaymentSuccessfullCalled = false
        isPaymentFailedCalled = false
    }
}
