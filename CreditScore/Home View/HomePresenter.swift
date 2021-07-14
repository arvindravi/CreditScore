//
//  HomePresenter.swift
//  CreditScore
//
//  Created by Arvind Ravi on 06/07/2021.
//

import Foundation
import CreditKit

protocol HomePresenterView: AnyObject {
    func homePresenter(_ presenter: HomePresenter, didSuccessfullyFetchCreditInformation information: CreditInformationRawResponse)
    func homePresenter(_ presenter: HomePresenter, didFailToFetchCreditInformationWith error: String)
}

final class HomePresenter {
    
    // MARK: - Properties -
    
    // MARK: Internal
    
    weak var view: HomePresenterView?
    
    // MARK: Private
    
    private let service: CreditKitType
    
    // MARK: - Initialiser -

    init(service: CreditKitType) {
        self.service = service
    }
    
    // MARK: - Methods -
    
    // MARK: Internal
    
    func fetchCreditScore() {
        service.fetchCreditScore { [weak self] result in
            guard let self = self else { return }
            self.handleResult(result)
        }
    }
    
    // MARK: Private
    
    private func handleResult(_ result: Result<CreditInformationRawResponse, CreditKit.Error>) {
        switch result {
        case .success(let creditInformationRawResponse):
            view?.homePresenter(self, didSuccessfullyFetchCreditInformation: creditInformationRawResponse)
        case .failure(let error):
            view?.homePresenter(self, didFailToFetchCreditInformationWith: error.localizedDescription)
        }
    }
}
