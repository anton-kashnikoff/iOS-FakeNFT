//
//  CheckoutViewModel.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 17.10.2023.
//

final class CheckoutViewModel {
    // MARK: - Private Properties
    
    private var router: CartFlowRouterProtocol
    private var orderService: CheckoutServiceProtocol
    
    private(set) var currencyID: String?
    
    @ObservableWrapper
    private(set) var currencyList = [Currency]()
    
    // MARK: - init()
    
    init(
        orderService: CheckoutServiceProtocol = OrderAndPaymentService.shared,
        currency: Currency? = nil,
        router: CartFlowRouterProtocol = CartFlowRouter.shared
    ) {
        self.router = router
        self.orderService = orderService
        self.orderService.checkoutVM = self
        currencyID = currency?.id
    }
    
    // MARK: - Public Properties
    
    func getCurrencyList() {
        currencyID = nil
        orderService.getAllCurrencies()
    }
    
    func setCurrencyList(to newCurrencyList: [Currency]) {
        currencyList = newCurrencyList
    }
    
    func setCurrencyTo(id: String) {
        currencyID = id
    }
    
    func makePayment() {
        guard let id = currencyID else { return }
        orderService.payWith(currecyID: id)
    }
    
    func paymentSuccessfull() {
        router.paymentSuccessfull()
    }
    
    func paymentFailed() {
        router.showPaymentError()
    }
    
    func networkError() {
        router.showNetworkError { [weak self] in
            self?.orderService.retry()
        }
    }
}
