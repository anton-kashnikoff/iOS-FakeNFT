//
//  CartViewModel.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 11.10.2023.
//

import Foundation

final class CartViewModel {
    // MARK: - Private Properties
    
    private var router: CartFlowRouterProtocol
    private var orderService: OrderServiceProtocol
    private var currentOrder = [ItemNFT]() {
        didSet {
            sortCurrentOrder()
        }
    }
    
    private(set)var sortingStyle = CartSortOrder.title {
        didSet {
            setSortingStyle()
            sortCurrentOrder()
        }
    }
    
    @ObservableWrapper
    private(set) var currentOrderSorted = [ItemNFT]()
    
    // MARK: - init()
    
    init(
        orderService: OrderServiceProtocol = OrderAndPaymentService.shared,
        router: CartFlowRouterProtocol = CartFlowRouter.shared
    ) {
        self.router = router
        self.orderService = orderService
        self.orderService.cartVM = self
        getSortingStyle()
    }
    
    func networkError() {
        router.showNetworkError { [weak self] in
            self?.orderService.retry()
        }
    }
    
    // MARK: - Private Properties
    
    private func getSortingStyle() {
        if let sortString = UserDefaults.standard.string(forKey: "cartSorting") {
            sortingStyle = switch sortString {
            case CartSortOrder.title.rawValue: .title
            case CartSortOrder.rating.rawValue: .rating
            case CartSortOrder.price.rawValue: .price
            default: .title
            }
        }
    }
    
    private func setSortingStyle() {
        UserDefaults.standard.set(sortingStyle.rawValue, forKey: "cartSorting")
    }
    
    private func sortCurrentOrder() {
        currentOrderSorted = sortNFT(currentOrder, by: sortingStyle)
    }
    
    // MARK: - Public Methods
    
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

    func sortNFT(_ items: [ItemNFT], by style: CartSortOrder) -> [ItemNFT] {
        switch style {
        case .price:
            items.sorted {
                $0.price > $1.price
            }
        case .rating:
            items.sorted {
                $0.rating > $1.rating
            }
        case .title:
            items.sorted {
                $0.name < $1.name
            }
        }
    }
    
    func setSortingStyle(to newStyle: CartSortOrder) {
        sortingStyle = newStyle
    }
}

// MARK: - CartItemCellDelegate

extension CartViewModel: CartItemCellDelegate {
    func removeItem(id: String) {
        orderService.removeItemFromOrder(id: id)
    }
}
