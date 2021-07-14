//
//  MockHomePresenterView.swift
//  CreditScoreTests
//
//  Created by Arvind Ravi on 07/07/2021.
//

import CreditKit
@testable import CreditScore

final class MockHomePresenterView: HomePresenterView {
    
    // MARK: - Custom Type -
    
    enum Event: Equatable {
        case didSuccessfullyFetchCreditInformation(withScore: Int)
        case didFailToFetchCreditInformationWith(error: String)
    }
    
    // MARK: - Properties -
    
    private(set) var capturedEvents = [Event]()
    
    // MARK: - Protocol Conformances -
    
    func homePresenter(_ presenter: HomePresenter, didSuccessfullyFetchCreditInformation information: CreditInformationRawResponse) {
        capturedEvents.append(.didSuccessfullyFetchCreditInformation(withScore: information.creditReportInfo.score))
    }
    
    func homePresenter(_ presenter: HomePresenter, didFailToFetchCreditInformationWith error: String) {
        capturedEvents.append(.didFailToFetchCreditInformationWith(error: error))
    }
}
