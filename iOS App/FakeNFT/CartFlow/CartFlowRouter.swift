//
//  CartFlowRouter.swift
//  FakeNFT
//
//  Created by Aleksey Yakushev on 15.10.2023.
//

import UIKit

protocol CartFlowRouterProtocol {
    var cartVC: CartViewController? { get set }
    var checkoutVC: CheckoutViewController? { get set }
    
    func showPaymentError()
    func showNetworkError(action: @escaping () -> Void)
    func showSortSheet()
    func showAgreementWebView()
    func showPaymentScreen()
    func showDeleteConfirmationForNFT(_ nft: ItemNFT?, removalAction: @escaping () -> Void)
    func paymentSuccessfull()
    func dismiss()
    func pop(_ viewController: UIViewController)
    func backToCatalog()
}

final class CartFlowRouter: CartFlowRouterProtocol {
    // MARK: - Static Properties
    
    static var shared = CartFlowRouter()
    
    // MARK: - Private Properties
    
    private let titleString = NSLocalizedString("alert.title", tableName: "CartFlowStrings", comment: "Ошибка")
    private let messageString = NSLocalizedString("alert.message", tableName: "CartFlowStrings", comment: "Сообщение")
    private let okString = NSLocalizedString("alert.ok", tableName: "CartFlowStrings", comment: "OK")
    private let cancelString = NSLocalizedString("alert.cancel", tableName: "CartFlowStrings", comment: "Отмена")
    private let retryString = NSLocalizedString("alert.retry", tableName: "CartFlowStrings", comment: "Повторить")
    
    // MARK: - Public Properties

    weak var cartVC: CartViewController?
    weak var checkoutVC: CheckoutViewController?
    
    // MARK: - init()
    
    private init() {}
    
    //MARK: - Private Methods
    
    private func createAlertAction(type: CartSortOrder) -> UIAlertAction {
        var title: String
        var identifier = String()

        switch type {
        case .price:
            title = NSLocalizedString("sortSheet.byPrice", tableName: "CartFlowStrings", comment: "По цене")
            identifier = "price_button"
        case .rating:
            title = NSLocalizedString("sortSheet.byRating", tableName: "CartFlowStrings", comment: "По рейтингу")
            identifier = "rating_button"
        case .title:
            title = NSLocalizedString("sortSheet.byName", tableName: "CartFlowStrings", comment: "По названию")
            identifier = "title_button"
        }

        let action = UIAlertAction(
            title: title,
            style: .default
        ) { [weak self] _ in
            self?.cartVC?.setSorting(to: type)
        }

        action.accessibilityIdentifier = identifier
        return action
    }
    
    // MARK: - Public Methods
    
    // Метод для отображения алерта с ошибкой оплаты
    func showPaymentError() {
        let alert = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: okString, style: .cancel))
        checkoutVC?.present(alert, animated: true)
    }
    
    // Метод для отображения алерта с ошибкой получения данных
    func showNetworkError(action: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }

            let alert = UIAlertController(
                title: self.titleString,
                message: self.messageString,
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(
                    title: retryString,
                    style: .cancel
                ) { _ in
                    action()
                    self.cartVC?.dismiss(animated: true)
                    self.cartVC?.showProgressView()
                }
            )
            
            alert.addAction(
                UIAlertAction(
                    title: cancelString,
                    style: .default
                ) { _ in
                    self.cartVC?.dismiss(animated: true)
                }
            )
            
            self.cartVC?.present(alert, animated: true)
        }
    }
    
    // Метод вызова алеррта выбора типа сортировки товаров в корзине
    func showSortSheet() {
        let sortSheet = UIAlertController(
            title: NSLocalizedString(
                "sortSheet.title",
                tableName: "CartFlowStrings",
                comment: "Сортировка"
            ),
            message: nil,
            preferredStyle: .actionSheet
        )

        sortSheet.addAction(createAlertAction(type: .price))
        sortSheet.addAction(createAlertAction(type: .rating))
        sortSheet.addAction(createAlertAction(type: .title))
        sortSheet.addAction(
            UIAlertAction(
                title: NSLocalizedString(
                    "sortSheet.close",
                    tableName: "CartFlowStrings",
                    comment: "Закрыть"
                ),
                style: .cancel
            )
        )
        
        cartVC?.present(sortSheet, animated: true)
    }
    
    func showAgreementWebView() {
        let webView = WebViewController()
        webView.model = WebViewModel(url: Config.userAgreementUrl)
        checkoutVC?.show(webView, sender: nil)
    }
    
    // Метод для перехода на экран оплаты
    func showPaymentScreen() {
        let checkout = CheckoutViewController()
        checkout.hidesBottomBarWhenPushed = true
        cartVC?.show(checkout, sender: nil)
    }
    
    // Метод для перехода на экран подтверждения оплаты
    func paymentSuccessfull() {
        let success = PaymentSuccessViewController()
        success.modalPresentationStyle = .fullScreen
        checkoutVC?.present(success, animated: true)
    }
    
    // Метод для отображения полноэкранного алерта при удалении товара
    func showDeleteConfirmationForNFT(_ nft: ItemNFT?, removalAction: @escaping () -> Void) {
        let viewController = DeleteConfirmationViewController()
        viewController.modalPresentationStyle = .overFullScreen
        viewController.removalAction = removalAction
        viewController.nftImageURL = nft?.images.first
        CartFlowRouter.shared.cartVC?.present(viewController, animated: true)
    }
    
    // Метод для скрытия текущего экрана
    func dismiss() {
        cartVC?.dismiss(animated: true)
    }
    
    // Метод для перехода назад по стеку NavigationController
    func pop(_ viewController: UIViewController) {
        viewController.navigationController?.popViewController(animated: true)
    }
    
    // Метод для возврата в каталог
    func backToCatalog() {
        if let checkoutVC { pop(checkoutVC) }

        if let tabBarController = cartVC?.parent?.tabBarController as? MainTabBarViewController {
            guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = scene.windows.first
            else {
                return
            }

            window.rootViewController = nil
            tabBarController.setupTabBar()
            
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve) {
                window.rootViewController = tabBarController
            }
        }
    }
}
