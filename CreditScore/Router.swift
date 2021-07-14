//
//  Router.swift
//  CreditScore
//
//  Created by Arvind Ravi on 06/07/2021.
//

import UIKit
import CreditKit

final class Router: UINavigationController {
    
    // MARK: - Dependencies -
    
    private let service: CreditKitType = CreditKit.shared
    
    // MARK: - Initialiser -
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let presenter = HomePresenter(service: service)
        let homeViewController = HomeViewController(presenter: presenter, router: self)
        setViewControllers([homeViewController], animated: true)
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Router: HomeViewControllerRouter {
    func homeViewControllerDidRequestCreditInformationView(_ viewController: HomeViewController, creditInformation: CreditInformationRawResponse) {
        let viewController = CreditInformationViewController(creditInformation: creditInformation)
        pushViewController(viewController, animated: true)
    }
}
