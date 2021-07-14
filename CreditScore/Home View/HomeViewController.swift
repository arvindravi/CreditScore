//
//  HomeViewController.swift
//  CreditScore
//
//  Created by Arvind Ravi on 06/07/2021.
//

import UIKit
import CreditKit

protocol HomeViewControllerRouter: AnyObject {
    func homeViewControllerDidRequestCreditInformationView(_ viewController: HomeViewController, creditInformation: CreditInformationRawResponse)
}

final class HomeViewController: UIViewController {
    
    private let presenter: HomePresenter
    private weak var router: HomeViewControllerRouter?
    private var creditInformation: CreditInformationRawResponse?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemRed
        return label
    }()
    
    private lazy var donutView: DonutView = {
        let view = DonutView()
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(presenter: HomePresenter, router: HomeViewControllerRouter) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupGestureRecognizer()
        view.backgroundColor = .systemBackground

        presenter.view = self
        presenter.fetchCreditScore()
    }
    
    private func setup() {
        view.addSubview(label)
        label.text = "0"
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
        
        view.addSubview(donutView)
        view.sendSubviewToBack(donutView)
        NSLayoutConstraint.activate([
            donutView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            donutView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor)
        ])
    }
    
    private func setupGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let creditInformation = creditInformation else {
            return
        }
        
        router?.homeViewControllerDidRequestCreditInformationView(self, creditInformation: creditInformation)
    }
    
    private func presentErrorAlert(with description: String) {
        let alert = UIAlertController(title: "Error",
                                      message: description,
                                      preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

extension HomeViewController: HomePresenterView {
    func homePresenter(_ presenter: HomePresenter, didSuccessfullyFetchCreditInformation information: CreditInformationRawResponse) {
        label.text = "\(information.creditReportInfo.score)"
        self.creditInformation = information
    }
    
    func homePresenter(_ presenter: HomePresenter, didFailToFetchCreditInformationWith error: String) {
        presentErrorAlert(with: error)
    }
}
