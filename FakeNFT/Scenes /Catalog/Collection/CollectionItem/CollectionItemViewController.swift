//
//  CollectionItemViewController.swift
//  FakeNFT
//
//  Created by Andy Kruch on 22.10.23.
//

import UIKit

final class CollectionItemViewController: UIViewController {
    
    // TO DO СОГЛАСНО ТЗ:
    // Экран частично реализуется наставником в ходе life coding. Реализация экрана студентами не требуется.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = .white
        
    }
    
    private func setupNavBar() {
        if let navBar = navigationController?.navigationBar {
            let leftImageButton = UIImage(systemName: "chevron.backward")?
                .withTintColor(.black)
                .withRenderingMode(.alwaysOriginal)
            let leftBarButton = UIBarButtonItem(
                image: leftImageButton,
                style: .plain,
                target: self,
                action: #selector(self.leftNavigationBarButtonTapped)
            )
            navigationItem.leftBarButtonItem = leftBarButton
            navBar.tintColor = .black
            navBar.isTranslucent = true
        }
    }
    
    @objc private func leftNavigationBarButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

