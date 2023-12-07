//
//  CartFlowUITests.swift
//  FakeNFTUITests
//
//  Created by Aleksey Yakushev on 26.10.2023.
//

@testable import FakeNFT
import XCTest

final class CartFlowUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        super.setUp()
        app.launch()
        
        let tabBar = app.tabBars.firstMatch
        let cartTabBarButton = tabBar.buttons["cart_tab"]
        
        XCTAssertTrue(cartTabBarButton.exists)
        XCTAssertTrue(cartTabBarButton.isHittable)
        
        cartTabBarButton.tap()
        
        sleep(5)
    }

    override func tearDown() {
        super.tearDown()
        app.terminate()
    }
    
    //MARK: - CartVC
    func testCartView() throws {
        let tableView = app.tables.firstMatch
        let cell = tableView.cells["cart_item_cell"].firstMatch
        
        XCTAssertTrue(cell.exists)
        XCTAssertEqual(cell.frame.intersects (tableView.frame), true)
    }
    
    func testDeleteConfirmation() throws {
        let tableView = app.tables.firstMatch
        let cell = tableView.cells["cart_item_cell"].firstMatch
        let removeButton = cell.buttons["remove_item_button"]
        
        XCTAssertTrue(removeButton.exists)
        XCTAssertTrue(removeButton.isHittable)
        
        removeButton.tap()
        
        let alertLabel = app.staticTexts["remove_item_alert"]
        let deleteButton = app.buttons["remove_item_proceed"]
        let cancelButton = app.buttons["remove_item_cancel"]
        
        XCTAssertTrue(alertLabel.exists)
        XCTAssertTrue(deleteButton.exists)
        XCTAssertTrue(cancelButton.exists)
    }
    
    func testSortSheet() throws {
        let navBar = app.navigationBars.firstMatch
        let sortButton = navBar.buttons["sort_button"]
        
        XCTAssertTrue (sortButton.exists)
        XCTAssertTrue (sortButton.isHittable)
        
        sortButton.tap()
        
        let priceButton = app.buttons["price_button"]
        let titleButton = app.buttons["title_button"]
        let ratingButton = app.buttons["rating_button"]
        XCTAssertTrue(priceButton.exists)
        XCTAssertTrue(titleButton.exists)
        XCTAssertTrue(ratingButton.exists)
    }
    
    //MARK: - CheckoutVC
    func testPaymentScreen() throws {
        let payButton = app.buttons["pay_button"]
        
        XCTAssertTrue(payButton.exists)
        XCTAssertTrue(payButton.isHittable)
        
        payButton.tap()
        
        sleep(3)
        
        let collection = app.collectionViews.firstMatch
        let cell = collection.cells["currency_cell"].firstMatch
        
        XCTAssertTrue(cell.exists)
        XCTAssertEqual(cell.frame.intersects (collection.frame), true)
    }
    
    func testWebView() throws {
        let payButton = app.buttons["pay_button"]
        payButton.tap()
        sleep(3)
        
        let agreementButton = app.buttons["agreement"]
        
        XCTAssertTrue(agreementButton.exists)
        XCTAssertTrue(agreementButton.isHittable)
        
        agreementButton.tap()
        
        let webView = app.webViews["web_view"]
        
        XCTAssertTrue(webView.exists)
                XCTAssertEqual(webView.frame.intersects (app.frame), true)
    }
}
