//
//  CheckoutViewModelTests.swift
//  FakeNFTTests
//
//  Created by Aleksey Yakushev on 25.10.2023.
//

@testable import FakeNFT
import XCTest

final class CheckoutViewModelTests: XCTestCase {
    var router: CartFlowRouterSpyProtocol & CartFlowRouterProtocol = CartFlowRouterSpy()
    var checkoutServiceSpy: CheckoutServiceSpyProtocol & CheckoutServiceProtocol = CheckoutServiceSpy()
    lazy var checkoutViewModel = CheckoutViewModel(orderService: checkoutServiceSpy, router: router)

    
    override func setUpWithError() throws {
        checkoutServiceSpy.checkoutVM = checkoutViewModel
    }
    
    override func tearDownWithError() throws {
        checkoutServiceSpy.reset()
    }
    
    //MARK: - Currency
    
    func testGetCurrencyList() {
        checkoutViewModel.getCurrencyList()
        XCTAssertNil(checkoutViewModel.currencyID)
        XCTAssertTrue(checkoutServiceSpy.getAllCurrenciesCalled)
    }
    
    func testSetCurrencyList() {
        let currencyList = MockCurrency.currencyList.shuffled()
        checkoutViewModel.setCurrencyList(to: currencyList)
        XCTAssertEqual(checkoutViewModel.currencyList, currencyList)
    }
    
    func testSetCurrency() {
        let currencyID = MockCurrency.currencyList.randomElement()?.id ?? "test"
        checkoutViewModel.setCurrencyTo(id: currencyID)
        XCTAssertEqual(checkoutViewModel.currencyID, currencyID)
    }
    
    //MARK: - Payment
    
    func testMakePayment() {
        let currencyID = MockCurrency.currencyList.randomElement()?.id ?? "test"
        checkoutViewModel.setCurrencyTo(id: currencyID)
        checkoutViewModel.makePayment()
        XCTAssertEqual(checkoutServiceSpy.payedWithCurrencyID, currencyID)
    }
    
    func testSuccessfulPayment() {
        checkoutViewModel.paymentSuccessfull()
        XCTAssertTrue(router.isPaymentSuccessfullCalled)
    }
    
    func testFailedPayment() {
        checkoutViewModel.paymentFailed()
        XCTAssertTrue(router.isPaymentFailedCalled)
    }
    
    func testNetworkError() {
        checkoutViewModel.networkError()
        XCTAssertTrue(router.isNetworkErrorCalled)
    }
}
