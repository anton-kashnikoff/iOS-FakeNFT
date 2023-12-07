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
    func pop(vc: UIViewController)
    func backToCatalog()
}

final class CartFlowRouter: CartFlowRouterProtocol {
    static var shared = CartFlowRouter()
    weak var cartVC: CartViewController?
    weak var checkoutVC: CheckoutViewController?
    
    private let titleString = NSLocalizedString("alert.title",
                                                tableName: "CartFlow",
                                                comment: "Ошибка")
    private let messageString = NSLocalizedString("alert.message",
                                                  tableName: "CartFlow",
                                                  comment: "Сообщение")
    private let okString = NSLocalizedString("alert.ok",
                                             tableName: "CartFlow",
                                             comment: "OK")
    private let cancelString = NSLocalizedString("alert.cancel",
                                                 tableName: "CartFlow",
                                                 comment: "Отмена")
    private let retryString = NSLocalizedString("alert.retry",
                                                tableName: "CartFlow",
                                                comment: "Повторить")
    
    private init() { }
    
    // Метод для отображения алерта с ошибкой оплаты
    func showPaymentError() {
        let alert = UIAlertController(title: titleString,
                                      message: messageString,
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okString, style: .cancel)
        alert.addAction(okAction)
        
        checkoutVC?.present(alert, animated: true)
    }
    
    // Метод для отображения алерта с ошибкой получения данных
    func showNetworkError(action: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let alert = UIAlertController(title: self.titleString,
                                          message: self.messageString,
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: cancelString, style: .default) { _ in
                self.cartVC?.dismiss(animated: true)
            }
            
            let retryAction = UIAlertAction(title: retryString, style: .cancel) { _ in
                action()
                self.cartVC?.dismiss(animated: true)
                self.cartVC?.showProgressView()
            }
            alert.addAction(retryAction)
            alert.addAction(okAction)
            
            self.cartVC?.present(alert, animated: true)
        }
    }
    
    // Метод вызова алеррта выбора типа сортировки товаров в корзине
    func showSortSheet() {
        let titleString = NSLocalizedString("sortSheet.title",
                                      tableName: "CartFlow",
                                      comment: "Сортировка")
        let sortSheet = UIAlertController(title: titleString,
                                          message: nil,
                                          preferredStyle: .actionSheet)

        sortSheet.addAction(createAlertAction(type: .price))
        sortSheet.addAction(createAlertAction(type: .rating))
        sortSheet.addAction(createAlertAction(type: .title))

        let closeString = NSLocalizedString("sortSheet.close",
                                            tableName: "CartFlow",
                                            comment: "Закрыть")
        let close = UIAlertAction(title: closeString, style: .cancel)
        sortSheet.addAction(close)
        
        cartVC?.present(sortSheet, animated: true)
    }
    
    func showAgreementWebView() {
        let webViewmodel = WebViewModel(url: Config.userAgreementUrl)
        let webView = WebViewController()
        webView.model = webViewmodel
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
        let vc = DeleteConfirmationViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.removalAction = removalAction
        vc.nftImageURL = nft?.images.first
        CartFlowRouter.shared.cartVC?.present(vc, animated: true)
    }
    
    // Метод для скрытия текущего экрана
    func dismiss() {
        cartVC?.dismiss(animated: true)
    }
    
    // Метод для перехода назад по стеку NavigationController
    func pop(vc: UIViewController) {
        vc.navigationController?.popViewController(animated: true)
    }
    
    // Метод для возврата в каталог
    func backToCatalog() {
        if let checkoutVC {
            pop(vc: checkoutVC)
        }
        if let tabBar = cartVC?.parent?.tabBarController as? MainTabBarViewController {
            guard let window = UIApplication.shared.windows.first else { return }
            window.rootViewController = nil
            tabBar.setupTabBar()
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: {
                window.rootViewController = tabBar
            }, completion: nil)
        }
    }
    
    //MARK: - Helper methods
    private func createAlertAction(type: CartSortOrder) -> UIAlertAction {
        var title: String?
        var identifier: String = ""
        switch type {
        case .price:
            title = NSLocalizedString("sortSheet.byPrice",
                                      tableName: "CartFlow",
                                      comment: "По цене")
            identifier = "price_button"
        case .rating:
            title = NSLocalizedString("sortSheet.byRating",
                                      tableName: "CartFlow",
                                      comment: "По рейтингу")
            identifier = "rating_button"
        case .title:
            title = NSLocalizedString("sortSheet.byName",
                                      tableName: "CartFlow",
                                      comment: "По названию")
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
}
