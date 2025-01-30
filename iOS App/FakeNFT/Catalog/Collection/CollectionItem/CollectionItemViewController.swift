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
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        view.backgroundColor = .white
    }
    
    // MARK: - Private Methods
    
    private func setupNavBar() {
        if let navigationBar = navigationController?.navigationBar {
            let leftImageButton = UIImage(systemName: "chevron.backward")?
                .withTintColor(.black)
                .withRenderingMode(.alwaysOriginal)
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(
                image: leftImageButton,
                style: .plain,
                target: self,
                action: #selector(self.leftNavigationBarButtonTapped)
            )
            
            navigationBar.tintColor = .black
            navigationBar.isTranslucent = true
        }
    }
    
    @objc
    private func leftNavigationBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
