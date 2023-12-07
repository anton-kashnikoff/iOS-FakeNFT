//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import Foundation

final class CartViewModel {
    private var router: CartFlowRouterProtocol
    private var orderService: OrderServiceProtocol
    private var currentOrder: [ItemNFT] = [] {
        didSet {
            sortCurrentOrder()
        }
    }
    private (set)var sortingStyle: CartSortOrder = .title {
        didSet {
            setSortingStyle()
            sortCurrentOrder()
        }
    }
    @Observable private(set) var currentOrderSorted: [ItemNFT] = []
    
    init(orderService: OrderServiceProtocol = OrderAndPaymentService.shared, router: CartFlowRouterProtocol = CartFlowRouter.shared) {
        self.router = router
        self.orderService = orderService
        self.orderService.cartVM = self
        getSortingStyle()
    }
    
    func networkError() {
            self.router.showNetworkError(action: { [weak self] in
                self?.orderService.retry()
            })
    }
    
    //MARK: - Order
    func setOrder(_ newOrder: [ItemNFT]) {
        currentOrder = newOrder
    }
    
    func getOrder() {
        orderService.getOrder()
    }
    
    func orderUpdated() {
        router.dismiss()
        getOrder()
    }
    
    //MARK: - Sorting
    func sortNFT(_ items: [ItemNFT], by style: CartSortOrder) -> [ItemNFT] {
        var newItems = items
        switch style {
        case .price:
            newItems.sort { item1, item2 in
                item1.price > item2.price
            }
        case .rating:
            newItems.sort { item1, item2 in
                item1.rating > item2.rating
            }
        case .title:
            newItems.sort { item1, item2 in
                item1.name < item2.name
            }
        }
        return newItems
    }
    
    private func getSortingStyle() {
        let defualts = UserDefaults.standard
        if let sortString = defualts.string(forKey: "cartSorting") {
            switch sortString {
            case CartSortOrder.title.rawValue:
                self.sortingStyle = .title
            case CartSortOrder.rating.rawValue:
                self.sortingStyle = .rating
            case CartSortOrder.price.rawValue:
                self.sortingStyle = .price
            default:
                self.sortingStyle = .title
            }
        }
    }
    
    private func setSortingStyle() {
        let defualts = UserDefaults.standard
        defualts.set(sortingStyle.rawValue, forKey: "cartSorting")
    }
    
    private func sortCurrentOrder() {
        currentOrderSorted = sortNFT(currentOrder, by: sortingStyle)
    }
    
    func setSortingStyle(to newStyle: CartSortOrder) {
        sortingStyle = newStyle
    }
}

//MARK: - Remove item from order
extension CartViewModel: CartItemCellDelegate {
    func removeItem(id: String) {
        orderService.removeItemFromOrder(id: id)
    }
}
