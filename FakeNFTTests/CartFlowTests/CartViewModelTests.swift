//
//  CartViewModelTests.swift
//  FakeNFTTests
//
//  Created by Aleksey Yakushev on 23.10.2023.
//

@testable import FakeNFT
import XCTest

final class CartViewModelTests: XCTestCase {
    var spyOrderService: OrderServiceProtocol & OrderServiceSpyProtocol = OrderServiceSpy()
    var router: CartFlowRouterProtocol & CartFlowRouterSpyProtocol = CartFlowRouterSpy()
    lazy var cartViewModel = CartViewModel(orderService: spyOrderService, router: router)

    override func setUpWithError() throws {
        spyOrderService.cartVM = cartViewModel
    }
    
    override func tearDownWithError() throws {
        spyOrderService.reset()
//        router.reset()
        cartViewModel.setSortingStyle(to: .title)
    }
    
    //MARK: - Orders
    func testSetOrder() {
        cartViewModel.setOrder(MockOrder.testItems)
        XCTAssertEqual(MockOrder.testItems, cartViewModel.currentOrderSorted)
    }
    
    func testGetOrder() {
        cartViewModel.getOrder()
        XCTAssertTrue(spyOrderService.isGetOrderCalled)
    }
    
    func testOrderUpdated() {
        cartViewModel.orderUpdated()
        XCTAssertTrue(router.isDismissCalled)
        XCTAssertTrue(spyOrderService.isGetOrderCalled)
    }
    
    func testRemoveItem() {
        let id = String(Int.random(in: 0...100))
        cartViewModel.removeItem(id: id)
        XCTAssertEqual(spyOrderService.removedID, id)
    }
    
    func testNetworkError() {
        cartViewModel.networkError()
        XCTAssertTrue(router.isNetworkErrorCalled)
    }
    
    //MARK: - Sorting
    
    func testSortNFT() {
        let items = MockOrder.testItems.shuffled()
        
        let titleSortedItems = cartViewModel.sortNFT(items,
                                                     by: .title)
        let priceSortedItems = cartViewModel.sortNFT(items,
                                                     by: .price)
        let ratingSortedItems = cartViewModel.sortNFT(items,
                                                      by: .rating)
        
        XCTAssertEqual(titleSortedItems, [MockOrder.testItem1,
                                          MockOrder.testItem2,
                                          MockOrder.testItem3,
                                          MockOrder.testItem4,
                                          MockOrder.testItem5])
        XCTAssertEqual(priceSortedItems, [MockOrder.testItem5,
                                          MockOrder.testItem1,
                                          MockOrder.testItem3,
                                          MockOrder.testItem4,
                                          MockOrder.testItem2])
        XCTAssertEqual(ratingSortedItems, [MockOrder.testItem3,
                                           MockOrder.testItem4,
                                           MockOrder.testItem2,
                                           MockOrder.testItem5,
                                           MockOrder.testItem1])
    }
    
    func testSetSortingStyle() {
        let styles: [FakeNFT.CartSortOrder] = [.price, .rating]
        let style = styles.randomElement() ?? .rating
        cartViewModel.setSortingStyle(to: style)
        
        XCTAssertEqual(cartViewModel.sortingStyle, style)
    }
    
    func testSortOrder() {
        cartViewModel.setOrder(MockOrder.testItems.shuffled())
        XCTAssertEqual(cartViewModel.currentOrderSorted, MockOrder.testItems)
    }
}

