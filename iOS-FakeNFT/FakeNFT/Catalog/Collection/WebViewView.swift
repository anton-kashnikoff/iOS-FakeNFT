//
//  WebViewView.swift
//  FakeNFT
//
//  Created by Andy Kruch on 22.10.23.
//

import UIKit
import WebKit

final class WebView: UIViewController {
    // MARK: - Private Properties
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    // MARK: - Public Properties
    
    var url: URL?
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .whiteUniversal
        
        addSubviews()
        setupConstraints()
        setupNavBar()
        loadWebView()
    }
    
    // MARK: - Private Properties
    
    private func loadWebView() {
        guard let url else { return }
        
        webView.load(URLRequest(url: url))
    }
    
    private func addSubviews() {
        view.addSubview(webView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func setupNavBar() {
        if let navigationBar = navigationController?.navigationBar {
            let backButtonImage = UIImage(systemName: "chevron.backward")?
                .withTintColor(.black)
                .withRenderingMode(.alwaysOriginal)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: backButtonImage,
                style: .plain,
                target: self,
                action: #selector(self.backButtonTapped)
            )
            
            navigationBar.tintColor = .whiteUniversal
        }
    }
        
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
    }
}
