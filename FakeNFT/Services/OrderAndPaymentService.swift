//
//  OrderAndPaymentService.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 13.10.2023.
//

import Foundation

//MARK: - Currency service
protocol CheckoutServiceProtocol {
    var checkoutVM: CheckoutViewModel? {get set}
    var currencyList: [Currency] {get}
    
    func payWith(currecyID: String)
    func getAllCurrencies()
    func retry()
}

//MARK: - Order service

protocol OrderServiceProtocol {
    var cartVM: CartViewModel? {get set}
    var currentOrderItems: [ItemNFT] {get}

    func getOrder()
    func removeItemFromOrder(id: String)
    func retry()
}

//MARK: - Cart service
final class OrderAndPaymentService: OrderServiceProtocol, CheckoutServiceProtocol {
    var cartVM: CartViewModel?
    var checkoutVM: CheckoutViewModel?

    static var shared = OrderAndPaymentService()
    private var networkClient: NetworkClient
    private var currentOrder: Order? = nil {
        didSet {
            getOrderItems()
        }
    }
    private(set) var currentOrderItems: [ItemNFT] = [] {
        didSet {
            cartVM?.setOrder(currentOrderItems)
        }
    }
    private(set) var currencyList: [Currency] = [] {
        didSet {
            checkoutVM?.setCurrencyList(to: currencyList)
        }
    }
    private lazy var lastRequest: () -> Void = { }
    
    //MARK: - URL paths
    private let orderPathString = "orders/1"
    private let getAllCurrenciesPathString = "currencies"
    private let paymentPathString = "/payment/"
    private let getNFTByIDString = "nft/"
    
    //MARK: - Lifecycle
    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
        self.lastRequest = self.getOrder
    }
    
    //MARK: - Helper methods
    private func getOrderItems() {
        var newOrderItems: [ItemNFT] = []
        let cartGroup = DispatchGroup()
        
        if let nfts = currentOrder?.nfts {
            for nft in nfts {
                cartGroup.enter()
                
                let urlString = Config.baseUrl + getNFTByIDString + nft
                let request = cartRequest(endpoint: URL(string: urlString))
                networkClient.send(request: request,
                                   type: ItemNFT.self,
                                   onResponse: { [weak self] result in
                    switch result {
                    case .success(let item):
                        newOrderItems.append(item)
                        cartGroup.leave()
                    case .failure(_):
                        cartGroup.leave()
                        self?.cartVM?.networkError()
                    }
                })
            }
        }
        
        cartGroup.notify(queue: .main) { [weak self] in
            self?.currentOrderItems = newOrderItems
        }
    }
    
    private func replaceOrder(with newOrder: Order) {
        let url = Config.baseUrl + orderPathString
        let request = cartChangeRequest(orderUpdateDTO: OrderUpdateDTO(nfts: newOrder.nfts,
                                                            id: newOrder.id),
                                        endpoint: URL(string: url)!)
        networkClient.send(request: request, type: Order.self, onResponse: { [weak self] result in
            switch result {
            case .success(let order):
                self?.currentOrder = order
            case .failure(_):
                self?.cartVM?.networkError()
            }
        })
    }
    
    //MARK: - Cart protocol methods
    func retry() {
        lastRequest()
    }
    
    func getOrder() {
        lastRequest = getOrder
        
        let urlString = Config.baseUrl + orderPathString
        let request = cartRequest(endpoint: URL(string: urlString))
        networkClient.send(request: request, type: Order.self, onResponse: { [weak self] result in
            guard let self else {
                return
            }
            switch result {
            case .success(let order):
                self.currentOrder = order
            case .failure(_):
                self.currentOrder = nil
                self.currentOrderItems = []
                self.cartVM?.networkError()
            }
        })
    }
    
    func getAllCurrencies() {
        lastRequest = getAllCurrencies
        
         let url = Config.baseUrl + getAllCurrenciesPathString
         let request = cartRequest(endpoint: URL(string: url)!)
         networkClient.send(request: request, type: [Currency].self, onResponse: { [weak self] result in
             switch result {
             case .success(let newCurrencylist):
                 self?.currencyList = newCurrencylist
             case.failure(_):
                 self?.checkoutVM?.networkError()
             }
         })
     }
    
    func payWith(currecyID: String) {
        lastRequest = { [weak self] in
            self?.payWith(currecyID: currecyID)
        }
        let urlString = Config.baseUrl + orderPathString + paymentPathString + currecyID
        let request = cartRequest(endpoint: URL(string: urlString))
        networkClient.send(request: request, type: OrderPaymentStatus.self, onResponse: { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    if status.success {
                        self?.checkoutVM?.paymentSuccessfull()
                    } else {
                        self?.checkoutVM?.paymentFailed()
                    }
                }
            case .failure(_):
                self?.checkoutVM?.networkError()
            }
        })
    }
    
    func removeItemFromOrder(id: String) {
        lastRequest = { [weak self] in
            self?.removeItemFromOrder(id: id)
        }
        
        let newNFTs = currentOrder?.nfts.filter { $0 != id } ?? []
        let newOrder = Order(nfts: newNFTs,
                             id: currentOrder?.id ?? "1")
        replaceOrder(with: newOrder)
    }
}
