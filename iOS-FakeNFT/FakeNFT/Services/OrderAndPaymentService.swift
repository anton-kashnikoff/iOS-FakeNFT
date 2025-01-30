//
//  OrderAndPaymentService.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 13.10.2023.
//

import Foundation

// MARK: - Currency service

protocol CheckoutServiceProtocol {
    var checkoutVM: CheckoutViewModel? { get set }
    var currencyList: [Currency] { get }
    
    func payWith(currecyID: String)
    func getAllCurrencies()
    func retry()
}

// MARK: - Order service

protocol OrderServiceProtocol {
    var cartVM: CartViewModel? { get set }
    var currentOrderItems: [ItemNFT] { get }

    func getOrder()
    func removeItemFromOrder(id: String)
    func retry()
}

// MARK: - Cart service

final class OrderAndPaymentService: OrderServiceProtocol, CheckoutServiceProtocol {
    // MARK: - Static Properties
    
    static var shared = OrderAndPaymentService()
    
    // MARK: - Private Properties

    private let orderPathString = "/orders/1"
    private let getAllCurrenciesPathString = "/currencies"
    private let paymentPathString = "/payment/"
    private let getNFTByIDString = "/nft/"
    
    private var networkClient: NetworkClient
    private var currentOrder: Order? {
        didSet {
            getOrderItems()
        }
    }
    
    private lazy var lastRequest: () -> Void = {}
    
    private(set) var currentOrderItems = [ItemNFT]() {
        didSet {
            cartVM?.setOrder(currentOrderItems)
        }
    }
    
    private(set) var currencyList = [Currency]() {
        didSet {
            checkoutVM?.setCurrencyList(to: currencyList)
        }
    }
    
    // MARK: - Public Properties
    
    var cartVM: CartViewModel?
    var checkoutVM: CheckoutViewModel?
    
    // MARK: - init()

    private init(networkClient: NetworkClient = DefaultNetworkClient()) {
        self.networkClient = networkClient
        lastRequest = getOrder
    }
    
    // MARK: - Private Methods
    
    private func getOrderItems() {
        var newOrderItems = [ItemNFT]()
        
        let cartGroup = DispatchGroup()
        
        if let nfts = currentOrder?.nfts {
            for nft in nfts {
                cartGroup.enter()
                
                networkClient
                    .send(
                        request: CartRequest(
                            endpoint: URL(
                                string: Config.baseUrl + getNFTByIDString + nft
                            )
                        ),
                        type: ItemNFT.self
                    ) { [weak self] result in
                    switch result {
                    case .success(let item):
                        newOrderItems.append(item)
                        cartGroup.leave()
                    case .failure:
                        cartGroup.leave()
                        self?.cartVM?.networkError()
                    }
                }
            }
        }
        
        cartGroup.notify(queue: .main) { [weak self] in
            self?.currentOrderItems = newOrderItems
        }
    }
    
    private func replaceOrder(with newOrder: Order) {
        let request = CartChangeRequest(
            orderUpdateDTO: OrderUpdateDTO(
                nfts: newOrder.nfts,
                id: newOrder.id
            ),
            endpoint: URL(string: Config.baseUrl + orderPathString)!
        )

        networkClient
            .send(request: request, type: Order.self) { [weak self] result in
                switch result {
                case .success(let order):
                    self?.currentOrder = order
                case .failure:
                    self?.cartVM?.networkError()
                }
            }
    }
    
    // MARK: - Public Methods
    
    func retry() {
        lastRequest()
    }
    
    func getOrder() {
        lastRequest = getOrder
        
        networkClient
            .send(
                request: CartRequest(
                    endpoint: URL(
                        string: Config.baseUrl + orderPathString
                    )
                ),
                type: Order.self
            ) { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let order):
                    self.currentOrder = order
                case .failure:
                    self.currentOrder = nil
                    self.currentOrderItems = []
                    self.cartVM?.networkError()
                }
            }
    }
    
    func getAllCurrencies() {
        lastRequest = getAllCurrencies
        
        networkClient
            .send(
                request: CartRequest(
                    endpoint: URL(
                        string: Config.baseUrl + getAllCurrenciesPathString
                    )!
                ),
                type: [Currency].self
            ) { [weak self] result in
                switch result {
                case .success(let newCurrencylist):
                    self?.currencyList = newCurrencylist
                case.failure:
                    self?.checkoutVM?.networkError()
                }
            }
     }
    
    func payWith(currecyID: String) {
        print(#function)
        lastRequest = { [weak self] in
            self?.payWith(currecyID: currecyID)
        }

        networkClient
            .send(
                request: CartRequest(
                    endpoint: URL(
                        string: Config.baseUrl + paymentPathString + currecyID
                    )
                ),
                type: OrderPaymentStatus.self
            ) { [weak self] result in
            switch result {
            case .success(let status):
                DispatchQueue.main.async {
                    if status.success {
                        self?.checkoutVM?.paymentSuccessfull()
                    } else {
                        self?.checkoutVM?.paymentFailed()
                    }
                }
            case .failure:
                self?.checkoutVM?.networkError()
            }
        }
    }
    
    func removeItemFromOrder(id: String) {
        lastRequest = { [weak self] in
            self?.removeItemFromOrder(id: id)
        }
        
        replaceOrder(
            with: Order(
                nfts: currentOrder?.nfts.filter { $0 != id } ?? [],
                id: currentOrder?.id ?? "1"
            )
        )
    }
}
