//
//  CreditKit+Mock.swift
//  CreditScoreTests
//
//  Created by Arvind Ravi on 07/07/2021.
//

import CreditKit
@testable import CreditScore

final class MockCreditKit: CreditKitType {
    enum Event: Equatable {
        case fetchCreditScore
        case fetchCreditScoreSuccess(score: Int)
        case fetchCreditScoreFailed(error: CreditKit.Error)
    }
    
    private(set) var capturedEvents = [Event]()
    
    var mockedSuccessResult: CreditInformationRawResponse?
    var mockedFailureResult: CreditKit.Error?
    
    func fetchCreditScore(result: @escaping CreditKit.CreditInformationResult) {
        capturedEvents.append(.fetchCreditScore)
        
        if let mockedSuccessResult = mockedSuccessResult {
            result(.success(mockedSuccessResult))
            capturedEvents.append(.fetchCreditScoreSuccess(score: mockedSuccessResult.creditReportInfo.score))
        }
        
        if let mockedFailureResult = mockedFailureResult {
            result(.failure(mockedFailureResult))
            capturedEvents.append(.fetchCreditScoreFailed(error: mockedFailureResult))
        }
    }
}
